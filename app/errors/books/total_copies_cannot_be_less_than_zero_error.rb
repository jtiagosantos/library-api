class Books::TotalCopiesCannotBeLessThanZeroError < StandardError
  def initialize
    super("Total copies cannot be less than zero")
  end
end
