class LoginMailer < ApplicationMailer
  def login
    @user = params[:user]

    mail(
      to: @user.email,
      subject: "[Wordless] Login"
    )
  end
end
