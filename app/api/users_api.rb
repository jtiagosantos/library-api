class UsersApi < Api
  helpers ::Helpers::ResponseHelper

  resource :users do
    desc "Register a new user"
    params do
      requires :username, type: String, desc: "User's username"
      requires :email, type: String, desc: "User's email"
    end
    post "/register" do
      Users::RegisterUserService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data, status=:created)
    end

    desc "List all registered users"
    get "/" do
      users = Users::ListUsersService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data)
    end

    desc "Search a user by id"
    params do
      requires :id, type: Integer, desc: "User's ID"
    end
    get "/:id" do
      Users::SearchUserByIdService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors, status=:not_found) if errors.any?

      render_success(data=data)
    end
  end
end
