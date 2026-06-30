class Loans::ListLoansService
  def call
    Loan.all
  end
end
