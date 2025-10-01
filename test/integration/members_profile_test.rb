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
    assert_select "img.gravatar"
    assert_match @member.quotes.count.to_s, response.body
    # Pagination only appears with many quotes
    @member.quotes.page(1).each do |quote|
      assert_match quote.content, response.body
    end
  end
end
