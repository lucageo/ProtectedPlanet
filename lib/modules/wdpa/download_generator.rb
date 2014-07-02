class Wdpa::DownloadGenerator
  def self.generate
    Download.generate 'all'

    collect_wdpa_ids = -> (country) {country.protected_areas.pluck(:wdpa_id)}

    Country.all.each do |country|
      Download.generate country.iso_3, collect_wdpa_ids.call(country)
    end

    Region.all.each do |region|
      wdpa_ids = Set.new region.countries.flat_map(&collect_wdpa_ids)
      Download.generate region.iso, wdpa_ids.to_a
    end
  end
end
