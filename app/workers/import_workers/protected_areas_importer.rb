class ImportWorkers::ProtectedAreasImporter < ImportWorkers::Base
  def perform table, limit, offset
    query = "SELECT * FROM #{table} LIMIT #{limit} OFFSET #{offset} ORDER BY wdpaid"

    Bystander.log(query)
    db.execute(query).to_a.each do |protected_area|
      import_pa(protected_area)
    end
  ensure
    finalise_job
  end

  def import_pa(protected_area_attributes)
    protected_area_attributes = protected_area_attributes.symbolize_keys

    protected_area_attributes = remove_geometry protected_area_attributes
    standardised_attributes = Wdpa::DataStandard.attributes_from_standards_hash(
      protected_area_attributes
    )

    if standardised_attributes.nil?
      Bystander.log("Protected Area with WDPAID = #{protected_area_attributes[:wdpaid]} was skipped")
      next
    end

    begin
      pa = ProtectedArea.create!(standardised_attributes)
      ImportWorkers::WikipediaSummaryWorker.perform_async pa.id
    rescue => err
      Bystander.log("""
        PA with WDPAID #{protected_area_attributes[:wdpaid]} was not imported because:
        > #{err.message}
      """)
    end
  end

  def db
    ActiveRecord::Base.connection
  end
end
