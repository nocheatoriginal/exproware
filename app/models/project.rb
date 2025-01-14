class Project < ApplicationRecord
  has_many_attached :participants_files
  has_many_attached :invitation_files
  has_many_attached :participation_certificate_files

  has_many :project_experts
  has_many :experts, through: :project_experts

  validates :project_title, presence: true
  validates :thematic_focus, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :client, presence: true
  validates :location, presence: true
  validates :invitation_status, presence: true
  validates :participation_certificate_status, presence: true

  enum :project_type, { delegation_visit: 0, lecturer_training: 1, professional_training: 2, summer_school: 3 }
  validates :project_type, presence: true
  validates :project_type, inclusion: { in: project_types.keys }
end
