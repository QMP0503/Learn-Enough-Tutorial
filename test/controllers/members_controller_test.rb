require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @member       = members(:michael)
    @other_member = members(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get members_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_member_path(@member)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch member_path(@member), params: { member: { name: @member.name, email: @member.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_member)
    get edit_member_path(@member)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_member)
    patch member_path(@member), params: { member: { name: @member.name,
                                                   email: @member.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Member.count" do
      delete member_path(@member)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_member)
    assert_no_difference "Member.count" do
      delete member_path(@member)
    end
    assert_redirected_to root_url
  end
end
