require 'test_helper'

class CountryControllerTest < ActionController::TestCase
  test '.show returns a 200 HTTP code' do
    global_region = FactoryGirl.create(:region, iso: 'GL')
    FactoryGirl.create(:regional_statistic, region: global_region, pa_area: 100)

    region = FactoryGirl.create(:region)
    FactoryGirl.create(:regional_statistic, region: region, pa_area: 100)

    country = FactoryGirl.create(:country, name: 'Orange Emirate', iso_3: 'PUM', region: region)

    FactoryGirl.create(:country_statistic,
      country: country,
      pa_area: 100,
      percentage_pa_cover: 50,
      percentage_pa_land_cover: 50,
      percentage_pa_eez_cover: 50,
      percentage_pa_ts_cover: 50,
      polygons_count: 100,
      points_count: 100
    )

    FactoryGirl.create(:pame_statistic, country: country)

    get :show, iso: 'PUM'
    assert_response :success
  end
end
