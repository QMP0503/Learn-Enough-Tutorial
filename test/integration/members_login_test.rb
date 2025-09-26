require "test_helper"

class MembersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @member = members(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_content
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @member.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_response :unprocessable_content
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    post login_path, params: { session: { email: @member.email,
                                          password: "password" } }
    assert is_logged_in?
    assert_redirected_to @member
    follow_redirect!
    assert_template "members/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", member_path(@member)
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", member_path(@member), count: 0
    # Simulate a member clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", member_path(@member), count: 0
  end

  test "login with remembering" do
    log_in_as(@member, remember_me: "1")
    assert_not cookies[:remember_token].blank?
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@member, remember_me: "1")
    # Log in again and verify that the cookie is deleted.
    log_in_as(@member, remember_me: "0")
    assert cookies[:remember_token].blank?
  end
end
