class User < ApplicationRecord
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  def auth_token_valid?
    auth_token.present? && auth_token_expires_at.future?
  end
end
