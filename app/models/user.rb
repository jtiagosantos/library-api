class User < ApplicationRecord
  ALLOWED_STATUS = %w[active blocked].freeze
  MAXIMUM_ACTIVE_LOANS = 3

  validates :username, :email, :status, presence: true
  validates :email, uniqueness: true

  enum :status, { active: "active", blocked: "blocked" }

  has_many :loans

  def active?
    status == "active"
  end

  def blocked?
    status == "blocked"
  end

  def has_too_many_loans?
    loans.where(status: "active").count >= MAXIMUM_ACTIVE_LOANS
  end

  def has_already_borrowed_book?(book)
    loans.where("book_id = ? AND status = ?", book.id, "active").exists?
  end

  def has_overdue_loans?
    loans.exists?(status: "overdue")
  end
end
