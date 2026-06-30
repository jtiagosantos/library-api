class Loan < ApplicationRecord
  enum :status, { active: "active", returned: "returned", overdue: "overdue" }

  belongs_to :user
  belongs_to :book
end
