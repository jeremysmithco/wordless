class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [500, 500], preprocessed: true
  end

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  def auth_token_valid?
    auth_token.present? && auth_token_expires_at.future?
  end
end
