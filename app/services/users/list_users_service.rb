class Users::ListUsersService
  def call(params)
    sort_field = params[:sort_field] || "created_at"
    sort_dir = (params[:sort_dir] || "desc").upcase

    User.order("#{sort_field} #{sort_dir}")
  end
end
