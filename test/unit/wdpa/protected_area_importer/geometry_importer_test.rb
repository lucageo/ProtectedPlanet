require 'test_helper'

class TestWdpaGeometryImporterService < ActiveSupport::TestCase
  test '.import updates all the PA geometries with the geometries in the
   given WDPA Release' do
    table_names = ["geom1", "geom2"]
    wdpa_release = Wdpa::Release.new
    wdpa_release.expects(:geometry_tables).returns(table_names)

    ActiveRecord::Base.connection.
      expects(:execute).
      with("""
        UPDATE protected_areas pa
        SET the_geom = import.wkb_geometry
        FROM #{table_names[0]} import
        WHERE pa.wdpa_id = import.wdpaid;
      """.squish)

    ActiveRecord::Base.connection.
      expects(:execute).
      with("""
        UPDATE protected_areas pa
        SET the_geom = import.wkb_geometry
        FROM #{table_names[1]} import
        WHERE pa.wdpa_id = import.wdpaid;
      """.squish)

    import_successful = Wdpa::ProtectedAreaImporter::GeometryImporter.import wdpa_release
    assert import_successful, "Expected the geometry import to be successful"
  end

  test '.import returns false if any update query fails' do
    wdpa_release = Wdpa::Release.new
    wdpa_release.expects(:geometry_tables).returns(["geom1"])

    ActiveRecord::Base.connection.
      expects(:execute).
      raises(ActiveRecord::StatementInvalid).
      once

    import_successful = Wdpa::ProtectedAreaImporter::GeometryImporter.import wdpa_release

    refute import_successful, "Expected import to fail"
  end
end
