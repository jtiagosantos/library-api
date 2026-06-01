class Users::RegisterUserService
  ALLOWD_STATUS = [ "active", "blocked" ]

  def call(params)
    invalidStatus = params[:status] && !ALLOWD_STATUS.include?(params[:status])

    raise Users::InvalidUserStatusError.new if invalidStatus

    usersExists = User.exists?(email: params[:email])

    raise Users::EmailAlreadyRegisteredError.new if usersExists

    User.create!(
      username: params[:username],
      email: params[:email],
      status: params[:status] || "active"
    )
  end
end
