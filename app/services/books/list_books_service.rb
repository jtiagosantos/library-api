class Books::ListBooksService < BaseService
  include ::Helpers::SortingHelper
  include ::Helpers::OrderingHelper

  ALLOWED_SORT_FIELDS = %w[title isbn published_at created_at].freeze
  ALLOWED_SORT_DIRS = %w[asc desc ASC DESC].freeze

  def call(input)
    title = input[:title]
    isbn = input[:isbn]

    make_sorting_values(input, ALLOWED_SORT_FIELDS, ALLOWED_SORT_DIRS) => { sort_field:, sort_dir: }
    make_ordering_values(input) => { limit:, offset: }

    books = Book
      .limit(limit)
      .offset(offset)
      .order("#{sort_field} #{sort_dir}")

    books = books.filter_by_title(title) if title.present?
    books = books.filter_by_isbn(isbn) if isbn.present?

    success(books)
  end
end
