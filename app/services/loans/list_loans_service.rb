class Loans::ListLoansService
  def call(params)
    user_id = params[:user_id]
    book_id = params[:book_id]
    status = params[:status]
    sort_field = params[:sort_field] || "created_at"
    sort_dir = (params[:sort_dir] || "desc").upcase
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    offset = (page * per_page) - per_page

    loans = Loan
      .limit(per_page)
      .offset(offset)
      .order("#{sort_field} #{sort_dir}")

    loans = loans.filter_by_user(user_id) if user_id.present?
    loans = loans.filter_by_book(book_id) if book_id.present?
    loans = loans.filter_by_status(status) if status.present?

    loans
  end
end
