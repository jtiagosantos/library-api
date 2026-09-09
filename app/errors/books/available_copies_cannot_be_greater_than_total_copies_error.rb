class Books::AvailableCopiesCannotBeGreaterThanTotalCopiesError < StandardError
  def initialize
    super("Available copies cannot be greater than total copies")
  end
end
