class Users::SearchUserByIdService < BaseService
  def call(id)
    user = User.find_by(id: id)

    add_error(EntityNotFoundError.new) unless user

    return failed if exists_error?

    success(user)
  end
end
