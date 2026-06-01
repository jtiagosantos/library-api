class Users::EmailAlreadyRegisteredError < BusinessError
  def initialize
    super("Email already registered", code: :conflict)
  end
end
