require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @member = members(:michael)
  end

  test "micropost interface" do
    log_in_as(@member)
    get root_path
    assert_select "nav.pagination", count: 0
    # Invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select "div#error_explanation"
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select "a", text: "delete"
    first_micropost = @member.microposts.page(1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different member (no delete links)
    get member_path(members(:archer))
    assert_select "a", { text: "delete", count: 0 }
  end

  test "micropost sidebar count" do
    log_in_as(@member)
    get root_path
    assert_match "#{@member.microposts.count} microposts", response.body
    # Member with zero microposts
    other_member = members(:malory)
    log_in_as(other_member)
    get root_path
    assert_match "0 micropost", response.body
    other_member.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
