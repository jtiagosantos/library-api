class Users::RegisterUserService < BaseService
  def call(input)
    status = input[:status] || "active"
    email = input[:email]
    username = input[:username]

    return failed if exists_error?

    user = User.create!(
      username: username,
      email: email,
      status: status
    )

    success(user)
  rescue => error
    add_error(error)
    failed
  end
end
