class Users::InvalidUserStatusError < StandardError
  def initialize
    super("Invalid user status")
  end
end
