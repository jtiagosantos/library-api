class Loans::LoanAlreadyReturnedError < BusinessError
  def initialize
    super("Loan has already been returned", code: :unprocessable_entity)
  end
end
