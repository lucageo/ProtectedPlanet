class Wdpa::Relation
  def initialize current_attributes
    @current_attributes = current_attributes
  end

  def create attribute, value
    if respond_to? attribute, true
      return send(attribute, value)
    end

    return value
  end

  private

  def legal_status value
    LegalStatus.where(name: value).first
  end

  def iucn_category value
    IucnCategory.where(name: value).first
  end

  def governance value
    Governance.where(name: value).first
  end

  def management_authority value
    ManagementAuthority.where(name: value).first
  end

  def countries value
    value.map do |iso_3|
      Country.where(iso_3: iso_3).first
    end
  end

  def sub_locations value
    sub_locations = value.map { |iso| SubLocation.where(iso: iso).first }
    sub_locations.compact
  end

  def designation value
    jurisdiction = Jurisdiction.where(name: @current_attributes[:jurisdiction]).first
    Designation.where({
      name: value,
      jurisdiction: jurisdiction
    }).first
  end
end
