class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :scores, dependent: :destroy
  has_many :schedules, dependent: :destroy

  enum role: { general: 0, guest: 1}

  validates :password, length: { in: 6..20 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
end
