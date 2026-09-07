class Loan < ApplicationRecord
  enum :status, { active: "active", returned: "returned", overdue: "overdue" }

  belongs_to :user
  belongs_to :book

  scope :overdues, -> {
    where("due_date < ? AND returned_at IS NULL AND status = 'active'", Time.now)
  }

  scope :filter_by_user, ->(user_id) { where(user_id: user_id) }

  scope :filter_by_book, ->(book_id) { where(book_id: book_id) }

  scope :filter_by_status, ->(status) { where(status: status) }
end
