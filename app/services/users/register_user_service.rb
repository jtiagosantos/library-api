class Users::RegisterUserService
  ALLOWD_STATUS = [ "active", "blocked" ]

  def call(params)
    invalidStatus = params[:status] && !ALLOWD_STATUS.include?(params[:status])

    if invalidStatus
      raise Users::InvalidUserStatusError.new
    end

    usersExists = User.find_by(email: params[:email])

    if usersExists
      raise Users::UserAlreadyRegisteredError.new
    end

    User.create!(
      username: params[:username],
      email: params[:email],
      status: params[:status] || "active"
    )
  end
end
