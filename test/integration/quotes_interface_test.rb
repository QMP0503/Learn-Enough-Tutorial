require "test_helper"

class QuotesInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @member = members(:michael)
  end

  test "quote interface" do
    log_in_as(@member)
    get root_path
    assert_select "nav.pagination", count: 0
    # Invalid submission
    assert_no_difference "Quote.count" do
      post quotes_path, params: { quote: { content: "" } }
    end
    assert_select "div#error_explanation"
    # Valid submission
    content = "This quote really ties the room together"
    assert_difference "Quote.count", 1 do
      post quotes_path, params: { quote: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select "a", text: "delete"
    first_quote = @member.quotes.page(1).first
    assert_difference "Quote.count", -1 do
      delete quote_path(first_quote)
    end
    # Visit different member (no delete links)
    get member_path(members(:archer))
    assert_select "a", { text: "delete", count: 0 }
  end

  test "quote sidebar count" do
    log_in_as(@member)
    get root_path
    assert_match "#{@member.quotes.count} quotes", response.body
    # Member with zero quotes
    other_member = members(:malory)
    log_in_as(other_member)
    get root_path
    assert_match "0 quote", response.body
    other_member.quotes.create!(content: "A quote")
    get root_path
    assert_match "1 quote", response.body
  end
end
