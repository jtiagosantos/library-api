class Books::AvailableCopiesCannotBeGreaterThanTotalCopiesError < BusinessError
  def initialize
    super("Available copies cannot be greater than total copies", code: :unprocessable_entity)
  end
end
