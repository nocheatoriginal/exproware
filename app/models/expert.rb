class Expert < ApplicationRecord
  has_many :project_experts, dependent: :destroy
  has_many :projects, through: :project_experts
  
  before_destroy :reset_user
  has_one :user
  has_and_belongs_to_many :categories
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :academic_title, presence: true
  validates :salary, presence: true
  validates :travel_willingness, presence: true
  validates :profile_image, presence: true
  validates :biography, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :salary, numericality: { greater_than: 0 }

  def reset_user
    return unless user

    user.update(expert_id: nil, initialized: false)
  end
end