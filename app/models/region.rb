class Region < ActiveRecord::Base
  include GeometryConcern

  has_many :countries
  has_many :protected_areas, through: :countries
  has_many :designations, -> { uniq }, through: :protected_areas
  has_many :iucn_categories, through: :protected_areas

  has_one :regional_statistic

  def statistic
    regional_statistic
  end

  def countries_providing_data
    countries.joins(:protected_areas).uniq
  end

  def protected_areas_with_iucn_categories
    valid_categories = "'Ia', 'Ib', 'II', 'II', 'IV', 'V', 'VI'"
    iucn_categories.where(
      "iucn_categories.name IN (#{valid_categories})"
    )
  end
end
