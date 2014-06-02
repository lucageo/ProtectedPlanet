require 'test_helper'

class TestWdpaProtectedAreaImporterService < ActiveSupport::TestCase
  test '.import imports the given array of objects as standardised
   Protected Areas' do
    pa_attributes = [{
      wdpaid: 1234,
      orig_name: 'Yosemite National Park'
    },{
      wdpaid: 4321,
      orig_name: 'Saratoga Creek Water District Park'
    }]

    imported = Wdpa::Service::ProtectedAreaImporter.import(pa_attributes)

    assert imported, "Expected importer to return true on success"
    assert_equal 2, ProtectedArea.count

    assert_not_nil ProtectedArea.where(wdpa_id: 1234).first
    assert_not_nil ProtectedArea.where(wdpa_id: 4321).first
  end

  test '.import does not standardise the attributes if the PA already
   exists' do
    pa = FactoryGirl.create(:protected_area, wdpa_id: 8765)
    pa_attributes = [{
      wdpaid: pa.wdpa_id
    }]

    Wdpa::DataStandard.expects(:attributes_from_standards_hash).never

    imported = Wdpa::Service::ProtectedAreaImporter.import(pa_attributes)

    assert imported, "Expected importer to return true on success"
    assert_equal 1, ProtectedArea.count
  end
end
