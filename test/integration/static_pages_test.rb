require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest
  test '/terms renders the Terms of Use' do
    get '/terms'
    assert_response :success
  end
end
