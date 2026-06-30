class Loans::ReturnBookService
  def call(params)
    loan = Loan.find_by(id: params[:id])

    raise EntityNotFoundError.new unless loan

    raise Loans::LoanAlreadyReturnedError.new if is_loan_returned?(loan)

    ActiveRecord::Base.transaction do
      loan.update!(
        returned_at: Time.current,
        status: "returned"
      )

      loan.book.increment!(:available_copies)

      loan
    end
  end

  private
    def is_loan_returned?(loan)
      loan.status == "returned"
    end
end
