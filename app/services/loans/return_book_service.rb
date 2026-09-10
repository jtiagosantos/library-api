class Loans::ReturnBookService < BaseService
  def call(input)
    id = input[:id]

    loan = Loan.find_by(id: id)

    if loan.nil?
      add_error(EntityNotFoundError.new)
      return failed
    end

    add_error(Loans::LoanAlreadyReturnedError.new) if loan.returned?

    return failed if exists_error?

    begin
      result = ActiveRecord::Base.transaction do
        loan.update!(
          returned_at: Time.current,
          status: "returned"
        )

        loan.book.increment!(:available_copies)

        loan
      end
    rescue ActiveRecord::RecordInvalid => error
      add_error(error)
    end

    return failed if exists_error?

    success(result)
  rescue => error
    add_error(error)
    failed
  end
end
