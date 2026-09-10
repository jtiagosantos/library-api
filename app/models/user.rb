class User < ApplicationRecord
  ALLOWED_STATUS = %w[active blocked].freeze

  validates :username, :email, :status, presence: true
  validates :email, uniqueness: true

  enum :status, { active: "active", blocked: "blocked" }

  has_many :loans
end
