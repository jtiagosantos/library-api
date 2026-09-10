class Book < ApplicationRecord
  validates :title, :isbn, :description, :total_copies, :available_copies, :published_at, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies,
    numericality: { greater_than: 0 }
  validates :available_copies,
    numericality: { greater_than_or_equal_to: 0 },
    comparison: { less_than_or_equal_to: :total_copies }

  has_many :loans

  scope :filter_by_title, ->(title) {
    where("title LIKE ?", "%" + Book.sanitize_sql_like(title) + "%")
  }

  scope :filter_by_isbn, ->(isbn) { where("isbn = ?", isbn) }

  def is_available?
    available_copies > 0
  end

  def is_unavailable?
    available_copies == 0
  end
end
