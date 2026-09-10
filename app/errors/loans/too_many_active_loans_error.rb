class Loans::TooManyActiveLoansError < StandardError
  def initialize
    super("User has too many active loans")
  end
end
