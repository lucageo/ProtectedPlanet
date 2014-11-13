class ProjectDownloadsGenerator
  class ItemsNotReadyError < StandardError; end;

  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform project_id
    @project = Project.find project_id

    while_generating do
      Download.generate "project_#{@project.id}_all", {wdpa_ids: wdpa_ids.to_a}
      {status: 'completed', links: links(@project.id)}.to_json
    end
  rescue ItemsNotReadyError
    ProjectDownloadsGenerator.perform_in(10.seconds, project_id)
  end

  private

  def wdpa_ids
    @wdpa_ids ||= begin
      unless @project.saved_searches.all?(&:population_completed?)
        raise ItemsNotReadyError
      end

      Set.new @project.items.flat_map(&:wdpa_ids)
    end
  end

  def filename
    "project_#{@project.id}_all"
  end

  def while_generating
    $redis.set("projects:#{@project.id}:all", {status: 'generating'}.to_json)
    $redis.set("projects:#{@project.id}:all", yield)
  end


  def links id
    ['csv', 'shp', 'kml'].each_with_object({}) do |type, hash|
      hash[type] = Download.link_to filename, type
    end.to_json
  end
end
