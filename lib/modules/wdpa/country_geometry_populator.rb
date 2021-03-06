class Wdpa::CountryGeometryPopulator
  def self.populate
    geometry = Geospatial::Geometry.new 'standard_polygons', 'wkb_geometry'
    geometry.repair

    Country.select(:id, :iso_3).order(:iso_3).each do |country|
      ImportWorkers::GeometryPopulatorWorker.perform_async country.id
    end
  end
end
