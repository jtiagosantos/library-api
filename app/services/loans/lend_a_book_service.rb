class Loans::LendABookService
  ACTIVE_USER_STATUS = "active"
  MAXIMUM_ACTIVE_LOANS_PER_USER = 3

  def call(params)
    user = User.find_by(id: params[:user_id])

    raise EntityNotFoundError.new unless user

    book = Book.find_by(id: params[:book_id])

    raise EntityNotFoundError.new unless book

    raise Users::InactiveUserError.new unless is_user_active?(user)

    raise Books::UnavailableBookError.new unless is_book_available?(book)

    raise Loans::TooManyActiveLoansError.new if user_has_too_many_loans?(user)

    raise Loans::AlreadyBorrowedBookError.new if user_has_already_borrowed_book?(user, book)

    raise Loans::OverdueLoansError.new if user_has_overdue_loans?(user)

    ActiveRecord::Base.transaction do
      loan = Loan.create!(
        user: user,
        book: book,
        borrowed_at: Time.current,
        due_date: Time.current + 7.days,
        status: "active"
      )

      book.decrement!(:available_copies)

      loan
    end
  end

  private
    def is_user_active?(user)
      user.status == ACTIVE_USER_STATUS
    end

    def is_book_available?(book)
      book.available_copies > 0
    end

    def user_has_too_many_loans?(user)
      user.loans.count >= MAXIMUM_ACTIVE_LOANS_PER_USER
    end

    def user_has_already_borrowed_book?(user, book)
      user.loans.exists?(book_id: book.id)
    end

    def user_has_overdue_loans?(user)
      user.loans.where("status = ?", "overdue").exists?
    end
end
