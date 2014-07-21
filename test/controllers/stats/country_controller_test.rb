require 'test_helper'

class Stats::CountryControllerTest < ActionController::TestCase
  test '.show returns a 200 HTTP code' do
    FactoryGirl.create(:protected_area)
    region = FactoryGirl.create(:region)
    FactoryGirl.create(:regional_statistic, 
      region: region, pa_land_area: 80, pa_marine_area: 20)
    country = FactoryGirl.create(:country, name: 'Orange Emirate', iso: 'PUM', region: region)
    FactoryGirl.create(:country_statistic, country: country,
      pa_area: 100, 
      percentage_pa_cover: 50,
      percentage_pa_land_cover: 50, 
      percentage_pa_eez_cover: 50, 
      percentage_pa_ts_cover: 50)
    get :show, iso: 'PUM'
    assert_response :success
  end
end
