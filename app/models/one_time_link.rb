class OneTimeLink < ApplicationRecord
  before_create :generate_token

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :used, inclusion: { in: [true, false] }
  validates :token, uniqueness: true
  validates :expires, presence: true

  scope :active, -> { where("expires > ?", Time.current).where(used: false) }

  def active?
    !(expired? || used)
  end

  def expired?
    expires < Time.current
  end

  private

  def generate_token
    self.token = SecureRandom.hex(15)
  end
end