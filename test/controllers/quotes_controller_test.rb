require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @quote = quotes(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Quote.count" do
      post quotes_path, params: { quote: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Quote.count" do
      delete quote_path(@quote)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong quote" do
    log_in_as(members(:michael))
    quote = quotes(:ants)
    assert_no_difference "Quote.count" do
      delete quote_path(quote)
    end
    assert_redirected_to root_url
  end
end
