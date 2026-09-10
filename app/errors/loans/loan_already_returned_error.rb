class Loans::LoanAlreadyReturnedError < StandardError
  def initialize
    super("Loan has already been returned")
  end
end
