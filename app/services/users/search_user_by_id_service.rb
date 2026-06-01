class Users::SearchUserByIdService
  def call(id)
    user = User.find_by(id: id)

    raise EntityNotFoundError.new unless user

    user
  end
end
