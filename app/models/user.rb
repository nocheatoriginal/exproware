class User < ApplicationRecord
  belongs_to :expert, optional: true
  enum :role, { user: 0, read_only: 1, admin: 2, staff: 3 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_destroy :ensure_another_admin_exists, if: :admin?
  before_update :ensure_another_admin_exists_for_role_change, if: :will_save_change_to_role?

  private

  # Check if the user is the last admin and prevent deletion
  def ensure_another_admin_exists
    if User.admin.count <= 1
      errors.add(:base, "Der letzte Admin kann nicht gelöscht werden!")
      throw(:abort)
    end
  end

  # Prevent role change if the user is the last admin
  def ensure_another_admin_exists_for_role_change
    if role_change.first == "admin" && role_change.last != "admin" && User.admin.count <= 1
      errors.add(:base, "Die Rolle des letzten Admins kann nicht geändert werden!")
      throw(:abort)
    end
  end
end
