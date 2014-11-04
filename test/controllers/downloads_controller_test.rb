require 'test_helper'

class DownloadsControllerTest < ActionController::TestCase
  test '#show redirects to the S3 bucket URL for the provided country ISO3 and
   type' do
    type = 'csv'
    country = FactoryGirl.create(:country, iso_3: 'CAN')
    link = "https://bucket.s3.com/#{country.iso_3}.#{type}"

    Download.expects(:link_to).returns(link)

    get :show, id: country.iso_3, type: type
    assert_redirected_to link
  end

  test 'POST :create, given a search term and filters, initiates a download generation' do
    search_term = 'manbone'
    options = {filters: {'type' => 'protected_area'}}
    token = '12345'

    search_mock = mock
    search_mock.stubs(:token).returns(token)
    Search.expects(:download).with(search_term, options).returns(search_mock)

    post :create, q: search_term, type: 'protected_area'

    json_response = JSON.parse(@response.body)
    assert_equal({'token' => token}, json_response)
  end

  test 'POST :create, given a search term, filters and a user, generates
   a download with the given user' do
    user = FactoryGirl.create(:user)
    sign_in user

    search_term = 'manbone'
    options = {filters: {'type' => 'protected_area'}, user: user}

    search_mock = mock()
    search_mock.stubs(:token)
    Search.expects(:download).with(search_term, options).returns(search_mock)

    post :create, q: search_term, type: 'protected_area'

    assert_response :success
  end

  test 'GET :poll, given a token, returns the properties of the given download' do
    search_properties = {'status' => 'preparing'}
    token = '12345'

    search_mock = mock()
    search_mock.stubs(:properties).returns(search_properties)
    Search.expects(:find).with(token).returns(search_mock)

    get :poll, token: token

    json_response = JSON.parse(@response.body)
    assert_equal search_properties, json_response
  end
end
