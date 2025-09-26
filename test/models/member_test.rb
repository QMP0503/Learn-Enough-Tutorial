require "test_helper"

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @member = Member.new(name: "Example Member", email: "member@example.com",
                         password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @member.valid?
  end

  test "name should be present" do
    @member.name = " "
    assert_not @member.valid?
  end

  test "email should be present" do
    @member.email = " "
    assert_not @member.valid?
  end

  test "name shouldn't be too long" do
    @member.name = "a" * 51
    assert_not @member.valid?
  end

  test "email shouldn't be too long" do
    @member.email = "a" * 101
    assert_not @member.valid?
  end
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @member.email = invalid_address
      assert_not @member.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  test "email addresses should be unique" do
    duplicate_member = @member.dup
    @member.save
    assert_not duplicate_member.valid?
  end

  test "email addresses shoud not be case sensitive" do
    duplicate_member = @member.dup
    duplicate_member.email = @member.email.upcase
    @member.save
    assert_not duplicate_member.valid?
  end

  test "password should be present (nonblank)" do
    @member.password = @member.password_confirmation = " " * 6
    assert_not @member.valid?
  end

  test "password should have a minimum length" do
    @member.password = @member.password_confirmation = "a" * 5
    assert_not @member.valid?
  end

  test "authenticated? should return false for a member with nil digest" do
    assert_not @member.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @member.save
    @member.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @member.destroy
    end
  end

  test "should follow and unfollow a member" do
    michael = members(:michael)
    archer  = members(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    # Members can't follow themselves.
    michael.follow(michael)
    assert_not michael.following?(michael)
  end
end
