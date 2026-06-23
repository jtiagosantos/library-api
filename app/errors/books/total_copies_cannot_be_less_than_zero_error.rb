class Books::TotalCopiesCannotBeLessThanZeroError < BusinessError
  def initialize
    super("Total copies cannot be less than zero", code: :unprocessable_entity)
  end
end
