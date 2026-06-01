class Users::ListUsersService
  def call
    User.all
  end
end
