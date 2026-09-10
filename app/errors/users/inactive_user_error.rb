class Users::InactiveUserError < StandardError
  def initialize
    super("User must be active")
  end
end
