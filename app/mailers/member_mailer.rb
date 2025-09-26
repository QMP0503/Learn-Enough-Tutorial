class MemberMailer < ApplicationMailer
  def account_activation(member)
    @member = member
    mail to: member.email, subject: "Account activation"
  end

  def password_reset(member)
    @member = member
    mail to: member.email, subject: "Password reset"
  end
end
