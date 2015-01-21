module ProtectedAreasHelper
  def map_bounds protected_area=nil
    return Rails.application.secrets.default_map_bounds unless protected_area

    {
      'from' => protected_area.bounds.first,
      'to' =>   protected_area.bounds.last
    }
  end

  def related_links? protected_area
    protected_area.wikipedia_article || protected_area.has_irreplaceability_info
  end

  def url_for_irreplaceability protected_area
    File.join(
      Rails.application.secrets.irreplaceability_info_base_url,
      protected_area.wdpa_id.to_s
    )
  end
end
