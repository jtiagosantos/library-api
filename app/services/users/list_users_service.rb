class Users::ListUsersService
  def call(params)
    sort_field = params[:sort_field] || "created_at"
    sort_dir = (params[:sort_dir] || "desc").upcase
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    offset = (page * per_page) - per_page

    User
      .limit(per_page)
      .offset(offset)
      .order("#{sort_field} #{sort_dir}")
  end
end
