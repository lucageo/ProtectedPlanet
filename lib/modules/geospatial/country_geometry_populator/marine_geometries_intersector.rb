module Geospatial::CountryGeometryPopulator::MarineGeometriesIntersector
  TEMPLATE = File.expand_path(
    File.join('../../templates', 'marine_geometry.erb'), __FILE__
  )

  MARINE_TYPES = ['eez', 'ts']

  def self.intersect country
    MARINE_TYPES.each do |marine_type|
      DB.execute render_template(TEMPLATE, binding)
    end
  end

  private

  DB = ActiveRecord::Base.connection

  def self.render_template template_path, binding
    template = ERB.new(File.read(template_path))
    template.result(binding).squish
  end


  def self.marine_geometry_attributes area_type
    "#{area_type}_geom"
  end
end
