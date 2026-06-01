class Users::UserAlreadyRegisteredError < BusinessError
  def initialize
    super("User already exists", code: :conflict)
  end
end
