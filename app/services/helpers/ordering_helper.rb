module Helpers::OrderingHelper
  def make_ordering_values(input)
    page_param = input[:page]
    per_page_param = input[:per_page]

    page = (page_param || 1).to_i
    limit = (per_page_param || 10).to_i
    offset = (page * limit) - limit

    {
      limit: limit,
      offset: offset
    }
  end
end
