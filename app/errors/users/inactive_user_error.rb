class Users::InactiveUserError < BusinessError
  def initialize
    super("User must be active", code: :unprocessable_entity)
  end
end
