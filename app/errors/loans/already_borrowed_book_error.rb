class Loans::AlreadyBorrowedBookError < StandardError
  def initialize
    super("User has already borrowed this book")
  end
end
