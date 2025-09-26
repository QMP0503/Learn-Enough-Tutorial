require "test_helper"

class MemberMailerTest < ActionMailer::TestCase
  test "account_activation" do
    member = members(:michael)
    member.activation_token = Member.new_token
    mail = MemberMailer.account_activation(member)
    assert_equal "Account activation", mail.subject
    assert_equal [ member.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match member.name,               mail.body.encoded
    assert_match member.activation_token,   mail.body.encoded
    assert_match CGI.escape(member.email),  mail.body.encoded
  end

  test "password_reset" do
    member = members(:michael)
    member.reset_token = Member.new_token
    mail = MemberMailer.password_reset(member)
    assert_equal "Password reset", mail.subject
    assert_equal [ member.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match member.reset_token,        mail.body.encoded
    assert_match CGI.escape(member.email),  mail.body.encoded
  end
end
