class Loans::SearchLoanByIdService < BaseService
  def call(params)
    id = params[:id]

    loan = Loan.find_by(id: id)

    add_error(EntityNotFoundError.new) unless loan

    return failed if exists_error?

    success(loan)
  end
end
