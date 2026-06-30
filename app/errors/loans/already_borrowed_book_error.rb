class Loans::AlreadyBorrowedBookError < BusinessError
  def initialize
    super("User has already borrowed this book", code: :unprocessable_entity)
  end
end
