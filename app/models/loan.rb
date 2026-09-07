class Loan < ApplicationRecord
  enum :status, { active: "active", returned: "returned", overdue: "overdue" }

  belongs_to :user
  belongs_to :book

  scope :overdues, -> { Loan.where("due_date < ? AND returned_at IS NULL AND status = 'active'", Time.now) }
end
