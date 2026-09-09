class Books::AvailableCopiesCannotBeNegativeError < StandardError
  def initialize
    super("Available copies cannot be negative")
  end
end
