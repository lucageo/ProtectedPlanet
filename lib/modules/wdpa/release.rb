class Wdpa::Release
  IMPORT_VIEW_NAME = "imported_protected_areas"

  def self.download
    wdpa_release = self.new
    wdpa_release.download

    wdpa_release
  end

  def initialize
    @start_time = Time.now
  end

  def download
    Wdpa::S3.download_current_wdpa_to zip_path
    system("unzip -j '#{zip_path}' '\*.gdb/\*' -d '#{gdb_path}'")

    import_tables.each do |original_table, std_table|
      Ogr::Postgres.import(
        gdb_path,
        original_table,
        std_table
      )
    end

    create_import_view
  end

  def import_tables
    geometry_tables.merge({source_table => source_table})
  end

  def geometry_tables
    gdb_metadata = Ogr::Info.new(gdb_path)
    geometry_tables = gdb_metadata.layers_matching(
      Wdpa::DataStandard::Matchers::GEOMETRY_TABLE
    )

    geometry_tables.each_with_object({}) do |tbl, hash|
      hash[tbl] = Wdpa::DataStandard.standardise_table_name(tbl)
    end
  end

  def source_table
    gdb_metadata = Ogr::Info.new(gdb_path)
    @source_table ||= gdb_metadata.layers_matching(Wdpa::DataStandard::Matchers::SOURCE_TABLE).first
  end

  def create_import_view
    attributes = Wdpa::DataStandard.common_attributes.join(', ')
    create_query = "CREATE OR REPLACE VIEW #{IMPORT_VIEW_NAME} AS "

    select_queries = []
    geometry_tables.each do |_, geometry_table|
      select_queries << "SELECT #{attributes} FROM #{geometry_table}"
    end

    create_query << select_queries.join(" UNION ALL ")

    db.execute(create_query)
  end

  def protected_areas
    geometry_tables.each_with_object([]) do |(_, std_table_name), protected_areas|
      protected_areas.concat(
        db.execute("SELECT * FROM #{std_table_name}").to_a
      )
    end
  end

  def sources
    db.execute("SELECT * FROM #{source_table}").to_a
  end

  def clean_up
    FileUtils.rm_rf(zip_path)
    FileUtils.rm_rf(gdb_path)
  end

  def zip_path
    "#{path_without_extension}.zip"
  end

  def gdb_path
    "#{path_without_extension}.gdb"
  end

  private

  def path_without_extension
    File.join(tmp_path, "wdpa-#{start_time}")
  end

  def tmp_path
    File.join(Rails.root, 'tmp')
  end

  def start_time
    @start_time.strftime("%Y-%m-%d-%H%M")
  end

  def db
    ActiveRecord::Base.connection
  end
end
