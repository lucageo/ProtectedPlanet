class Ogr::Postgres
  def import file: file_path, to: database_name
    @file_path = file
    @database_name = to
    @db_config = Rails.configuration.database_configuration[Rails.env]

    system(ogr_command)
  end

  private

  def ogr_command
    ogr_command_template.squish
  end

  def ogr_command_template
    template_path = File.join(File.dirname(__FILE__), 'ogr_postgres_command.erb')
    template = File.read(template_path)

    ERB.new(template).result binding
  end
end