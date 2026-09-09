class Users::EmailAlreadyRegisteredError < StandardError
  def initialize
    super("Email already registered")
  end
end
