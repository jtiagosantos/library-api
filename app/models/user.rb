class User < ApplicationRecord
  enum :status, { active: "active", blocked: "blocked" }

  has_many :loans
end
