class Books::AvailableCopiesCannotBeNegativeError < BusinessError
  def initialize
    super("Available copies cannot be negative", code: :unprocessable_entity)
  end
end
