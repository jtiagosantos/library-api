class Users::InvalidUserStatusError < BusinessError
  def initialize
    super("Invalid user status", code: :unprocessable_entity)
  end
end
