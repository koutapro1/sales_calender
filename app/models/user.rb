class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :sales, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
