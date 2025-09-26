ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  include ApplicationHelper
  # Load all fixtures from test/fixtures/*.yml for all tests
  fixtures :all

  # Returns true if a test member is logged in.
  def is_logged_in?
    !session[:member_id].nil?
  end

  # Log in as a particular member.
  def log_in_as(member)
    session[:member_id] = member.id
  end

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Log in as a particular member.
  def log_in_as(member, password: "password", remember_me: "1")
    post login_path, params: { session: { email: member.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
