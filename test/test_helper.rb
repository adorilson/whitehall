ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factories'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_not(condition)
    assert_equal false, condition
  end
end

class ActionController::TestCase
  def login_as(name, attributes={})
    user = User.find_or_create_by_name(name, attributes)
    session[:user_id] = user.id
    user
  end
  
  def assert_login_required
    assert_redirected_to login_path
  end
end