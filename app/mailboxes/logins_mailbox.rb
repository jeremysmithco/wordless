class LoginsMailbox < ApplicationMailbox
  def process
    user = User.find_or_initialize_by(email: mail.from&.first)

    unless user.auth_token_valid?
      user.assign_attributes(auth_token: SecureRandom.urlsafe_base64, auth_token_expires_at: 30.minutes.from_now)
    end

    user.save!

    LoginMailer.with(user: user).login.deliver_now
  end
end
