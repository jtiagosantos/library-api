class Users::RegisterUserService
  ALLOWD_STATUS = [ "active", "blocked" ]

  def call(params)
    raise Users::InvalidUserStatusError.new if is_invalid_status?(params[:status])

    usersExists = User.exists?(email: params[:email])

    raise Users::EmailAlreadyRegisteredError.new if usersExists

    User.create!(
      username: params[:username],
      email: params[:email],
      status: params[:status] || "active"
    )
  end

  private
    def is_invalid_status?(status)
      status && !ALLOWD_STATUS.include?(status)
    end
end
