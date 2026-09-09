class Users::RegisterUserService < BaseService
  ALLOWD_STATUS = [ "active", "blocked" ]

  def call(params)
    status = params[:status] || "active"
    email = params[:email]
    username = params[:username]

    add_error(Users::InvalidUserStatusError.new) if is_invalid_status?(status)

    add_error(Users::EmailAlreadyRegisteredError.new) if user_exists?(email)

    return failed if exists_error?

    user = User.create!(
      username: username,
      email: email,
      status: status
    )

    success(user)
  end

  private
    def is_invalid_status?(status)
      status && !ALLOWD_STATUS.include?(status)
    end

    def user_exists?(email)
      User.exists?(email: email)
    end
end
