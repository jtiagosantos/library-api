class Loans::LendABookService < BaseService
  ACTIVE_USER_STATUS = "active"
  MAXIMUM_ACTIVE_LOANS_PER_USER = 3

  def call(input)
    user_id = input[:user_id]
    book_id = input[:book_id]

    user = User.find_by(id: user_id)

    if user.nil?
      add_error(EntityNotFoundError.new)
      return failed
    end

    book = Book.find_by(id: book_id)

    if book.nil?
      add_error(EntityNotFoundError.new)
      return failed
    end

    add_error(Users::InactiveUserError.new) unless is_user_active?(user)

    add_error(Books::UnavailableBookError.new) unless is_book_available?(book)

    add_error(Loans::TooManyActiveLoansError.new) if user_has_too_many_loans?(user)

    add_error(Loans::AlreadyBorrowedBookError.new) if user_has_already_borrowed_book?(user, book)

    add_error(Loans::OverdueLoansError.new) if user_has_overdue_loans?(user)

    return failed if exists_error?

    begin
      result = ActiveRecord::Base.transaction do
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
    rescue ActiveRecord::RecordInvalid => error
      add_error(error)
    end

    return failed if exists_error?

    success(result)
  end

  private
    def is_user_active?(user)
      user.status == ACTIVE_USER_STATUS
    end

    def is_book_available?(book)
      book.available_copies > 0
    end

    def user_has_too_many_loans?(user)
      user.loans.where(status: "active").count >= MAXIMUM_ACTIVE_LOANS_PER_USER
    end

    def user_has_already_borrowed_book?(user, book)
      user.loans.exists?("book_id = ? AND status = ?", book.id, "active")
    end

    def user_has_overdue_loans?(user)
      user.loans.exists?(status: "overdue")
    end
end
