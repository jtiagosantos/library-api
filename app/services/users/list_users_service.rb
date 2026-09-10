class Users::ListUsersService < BaseService
  include ::Helpers::SortingHelper
  include ::Helpers::OrderingHelper

  ALLOWED_SORT_FIELDS = %w[username email created_at].freeze
  ALLOWED_SORT_DIRS = %w[asc desc ASC DESC].freeze

  def call(input)
    make_sorting_values(input, ALLOWED_SORT_FIELDS, ALLOWED_SORT_DIRS) => { sort_field:, sort_dir: }
    make_ordering_values(input) => { limit:, offset: }

    users = User
      .limit(limit)
      .offset(offset)
      .order(Arel.sql("#{sort_field} #{sort_dir}"))

    success(users)
  end
end
