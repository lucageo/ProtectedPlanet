require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test '.bounds returns the bounding box for the Country geometry' do
    country = FactoryGirl.create(:country, bounding_box: 'POLYGON ((-1 0, 0 1, 1 2, 1 0, -1 0))')

    assert_equal [[0, -1], [2, 1]], country.bounds
  end

  test '.protected_areas returns the number of Protected Areas in the country' do
    country = FactoryGirl.create(:country)

    expected_pas = [
      FactoryGirl.create(:protected_area, countries: [country]),
      FactoryGirl.create(:protected_area, countries: [country])
    ]

    FactoryGirl.create(:protected_area)

    protected_areas = country.protected_areas

    assert_equal 2, protected_areas.count
    assert_same_elements expected_pas.map(&:id), protected_areas.pluck(:id)
  end

  test ".designations returns the designations for the Country's Protected Areas" do
    designation_1 = FactoryGirl.create(:designation, name: 'Lionel Messi')
    designation_2 = FactoryGirl.create(:designation, name: 'Robin Van Persie')
    designation_3 = FactoryGirl.create(:designation, name: 'Cristiano Ronaldo')

    country_1 = FactoryGirl.create(:country)
    country_2 = FactoryGirl.create(:country)
    country_3 = FactoryGirl.create(:country)

    FactoryGirl.create(:protected_area, designation: designation_1, countries: [country_1])
    FactoryGirl.create(:protected_area, designation: designation_2, countries: [country_1])
    FactoryGirl.create(:protected_area, designation: designation_2, countries: [country_2])
    FactoryGirl.create(:protected_area, designation: designation_3, countries: [country_3])

    assert_equal 2, country_1.designations.count
  end

  test '.protected_areas_with_iucn_categories returns all Protected
   Areas with valid IUCN categories' do
    iucn_category_1 = FactoryGirl.create(:iucn_category, name: 'Ib')
    iucn_category_2 = FactoryGirl.create(:iucn_category, name: 'V')
    invalid_iucn_category = FactoryGirl.create(:iucn_category, name: 'Pepe')

    country_1 = FactoryGirl.create(:country)
    country_2 = FactoryGirl.create(:country)
    country_3 = FactoryGirl.create(:country)

    FactoryGirl.create(:protected_area, iucn_category: iucn_category_1, countries: [country_1] )
    FactoryGirl.create(:protected_area, iucn_category: iucn_category_2, countries: [country_1])
    FactoryGirl.create(:protected_area, iucn_category: invalid_iucn_category, countries: [country_2])
    FactoryGirl.create(:protected_area, iucn_category: iucn_category_2, countries: [country_3])

    assert_equal 2, country_1.protected_areas_with_iucn_categories.count
  end
end
