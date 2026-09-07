class Loans::MarkLoanAsOverdueService
  def call
    Loan.overdues.update_all(status: "overdue")
  end
end
