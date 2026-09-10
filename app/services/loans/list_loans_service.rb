class Loans::ListLoansService < BaseService
  include ::Helpers::SortingHelper
  include ::Helpers::OrderingHelper

  ALLOWED_SORT_FIELDS = %w[borrowed_at due_date created_at].freeze
  ALLOWED_SORT_DIRS = %w[asc desc ASC DESC].freeze

  def call(input)
    user_id = input[:user_id]
    book_id = input[:book_id]
    status = input[:status]

    make_sorting_values(input, ALLOWED_SORT_FIELDS, ALLOWED_SORT_DIRS) => { sort_field:, sort_dir: }
    make_ordering_values(input) => { limit:, offset: }

    loans = Loan
      .limit(limit)
      .offset(offset)
      .order("#{sort_field} #{sort_dir}")

    loans = loans.filter_by_user(user_id) if user_id.present?
    loans = loans.filter_by_book(book_id) if book_id.present?
    loans = loans.filter_by_status(status) if status.present?

    success(loans)
  end
end
