module Helpers::SortingHelper
  def make_sorting_values(input, allowed_sort_fields, allowed_sort_dirs)
    sort_field_param = input[:sort_field]
    sort_dir_param = input[:sort_dir]

    sort_field = allowed_sort_fields.include?(sort_field_param) ? sort_field_param : "created_at"
    sort_dir = allowed_sort_dirs.include?(sort_dir_param) ? sort_dir_param.upcase : "ASC"

    {
      sort_field: sort_field,
      sort_dir: sort_dir
    }
  end
end
