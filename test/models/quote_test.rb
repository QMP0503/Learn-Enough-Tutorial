require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  def setup
    @member = members(:michael)
    @quote = @member.quotes.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @quote.valid?
  end

  test "author id should be present" do
    @quote.author_id = nil
    assert_not @quote.valid?
  end

  test "content should be present" do
    @quote.content = "   "
    assert_not @quote.valid?
  end

  test "content should be at most 280 characters" do
    @quote.content = "a" * 281
    assert_not @quote.valid?
  end

  test "order should be most recent first" do
    assert_equal quotes(:most_recent), Quote.first
  end
end
