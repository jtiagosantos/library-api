class Loans::ListLoansService
  def call
    MarkLoanAsOverdueJob.perform_later

    Loan.all
  end
end
