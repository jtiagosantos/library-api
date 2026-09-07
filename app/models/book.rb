class Book < ApplicationRecord
  has_many :loans

  scope :filter_by_title, ->(title) {
    where("title LIKE ?", "%" + Book.sanitize_sql_like(title) + "%")
  }

  scope :filter_by_isbn, ->(isbn) { where("isbn = ?", isbn) }
end
