class UsersApi < Api
  resource :users do
    desc "Register a new user"
    params do
      requires :username, type: String, desc: "User's username"
      requires :email, type: String, desc: "User's email"
    end
    post "/register" do
      Users::RegisterUserService.new.call(params)
    end

    desc "List all registered users"
    get "/" do
      users = Users::ListUsersService.new.call
      { data: users }
    end
  end
end
