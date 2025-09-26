require "test_helper"

class MembersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @member = members(:michael)
  end

  test "profile display" do
    get member_path(@member)
    assert_template "members/show"
    assert_select "title", full_title(@member.name)
    assert_select "h1", text: @member.name
    assert_select "h1>img.gravatar"
    assert_match @member.microposts.count.to_s, response.body
    # Pagination only appears with many microposts
    @member.microposts.page(1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
