class Loans::ListLoansService
  def call(params)
    user_id = params[:user_id]
    book_id = params[:book_id]
    status = params[:status]
    loans = Loan.all

    loans = loans.filter_by_user(user_id) if user_id.present?
    loans = loans.filter_by_book(book_id) if book_id.present?
    loans = loans.filter_by_status(status) if status.present?

    loans
  end
end
