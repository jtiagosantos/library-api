class Loans::SearchLoanByIdService
  def call(params)
    loan = Loan.find_by(id: params[:id])

    raise EntityNotFoundError.new unless loan

    loan
  end
end
