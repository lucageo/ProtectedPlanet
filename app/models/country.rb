class Country < ActiveRecord::Base
  include GeometryConcern

  has_and_belongs_to_many :protected_areas

  has_one :country_statistic
  has_one :pame_statistic

  belongs_to :region
  belongs_to :region_for_index, -> { select('regions.id, regions.name') }, :class_name => 'Region', :foreign_key => 'region_id'

  has_many :sub_locations
  has_many :designations, -> { uniq }, through: :protected_areas
  has_many :iucn_categories, through: :protected_areas

  belongs_to :parent, class_name: "Country", foreign_key: :country_id
  has_many :children, class_name: "Country"

  def wdpa_ids
    protected_areas.map(&:wdpa_id)
  end

  def statistic
    country_statistic
  end

  def protected_areas_with_iucn_categories
    valid_categories = "'Ia', 'Ib', 'II', 'II', 'IV', 'V', 'VI'"
    iucn_categories.where(
      "iucn_categories.name IN (#{valid_categories})"
    )
  end

  def self.data_providers
    joins(:protected_areas).uniq
  end

  def as_indexed_json options={}
    self.as_json(
      only: [:id, :name, :iso_3],
      include: {
        region_for_index: { only: [:id, :name] }
      }
    )
  end

  def random_protected_areas wanted=1
    random_offset = rand(protected_areas.count-wanted)
    protected_areas.offset(random_offset).limit(wanted)
  end

  def protected_areas_per_designation(jurisdiction=nil)
    ActiveRecord::Base.connection.execute("""
      SELECT designations.id AS designation_id, designations.name AS designation_name, pas_per_designations.count
      FROM designations
      INNER JOIN (
        #{protected_areas_inner_join(:designation_id)}
      ) AS pas_per_designations
        ON pas_per_designations.designation_id = designations.id
      #{"WHERE designations.jurisdiction_id = #{jurisdiction.id}" if jurisdiction}
    """)
  end

  def protected_areas_per_jurisdiction
    ActiveRecord::Base.connection.execute("""
      SELECT jurisdictions.name, COUNT(*)
      FROM jurisdictions
      INNER JOIN designations ON jurisdictions.id = designations.jurisdiction_id
      INNER JOIN (
        SELECT protected_areas.designation_id
        FROM protected_areas
        INNER JOIN countries_protected_areas
          ON protected_areas.id = countries_protected_areas.protected_area_id
          AND countries_protected_areas.country_id = #{self.id}
      ) AS pas_for_country ON pas_for_country.designation_id = designations.id
      GROUP BY jurisdictions.name
    """)
  end

  def sources_per_jurisdiction
    ActiveRecord::Base.connection.execute("""
      SELECT jurisdictions.name, COUNT(DISTINCT protected_areas_sources.source_id)
      FROM jurisdictions
      INNER JOIN designations ON jurisdictions.id = designations.jurisdiction_id
      INNER JOIN (
        SELECT protected_areas.id, protected_areas.designation_id
        FROM protected_areas
        INNER JOIN countries_protected_areas
          ON protected_areas.id = countries_protected_areas.protected_area_id
          AND countries_protected_areas.country_id = #{self.id}
      ) AS pas_for_country ON pas_for_country.designation_id = designations.id
      INNER JOIN
        protected_areas_sources
      ON
        protected_areas_sources.protected_area_id = pas_for_country.id
      GROUP BY jurisdictions.name
    """)
  end

  def protected_areas_per_iucn_category
    ActiveRecord::Base.connection.execute("""
      SELECT iucn_categories.id AS iucn_category_id, iucn_categories.name AS iucn_category_name, pas_per_iucn_categories.count, round((pas_per_iucn_categories.count::decimal/(SUM(pas_per_iucn_categories.count) OVER ())::decimal) * 100, 2) AS percentage
      FROM iucn_categories
      INNER JOIN (
        #{protected_areas_inner_join(:iucn_category_id)}
      ) AS pas_per_iucn_categories
        ON pas_per_iucn_categories.iucn_category_id = iucn_categories.id
    """)
  end

  def protected_areas_per_governance
    ActiveRecord::Base.connection.execute("""
      SELECT governances.id AS governance_id, governances.name AS governance_name, governances.governance_type AS governance_type, pas_per_governances.count, round((pas_per_governances.count::decimal/(SUM(pas_per_governances.count) OVER ())::decimal) * 100, 2) AS percentage
      FROM governances
      INNER JOIN (
        #{protected_areas_inner_join(:governance_id)}
      ) AS pas_per_governances
        ON pas_per_governances.governance_id = governances.id
    """)
  end

  private

  def protected_areas_inner_join group_by
    """
      SELECT #{group_by}, COUNT(protected_areas.id) AS count
      FROM protected_areas
      INNER JOIN countries_protected_areas
        ON protected_areas.id = countries_protected_areas.protected_area_id
        AND countries_protected_areas.country_id = #{self.id}
      GROUP BY #{group_by}
    """
  end
end
