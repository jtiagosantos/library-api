class Loans::LendABookService < BaseService
  ACTIVE_USER_STATUS = "active"
  MAXIMUM_ACTIVE_LOANS_PER_USER = 3

  def call(input)
    user_id = input[:user_id]
    book_id = input[:book_id]

    user = User.find_by(id: user_id)

    book = Book.find_by(id: book_id)

    if user.nil? || book.nil?
      add_error(EntityNotFoundError.new)
      return failed
    end

    if user.blocked?
      add_error(Users::InactiveUserError.new)
      return failed
    end

    if book.is_unavailable?
      add_error(Books::UnavailableBookError.new)
      return failed
    end

    if user.has_too_many_loans?
      add_error(Loans::TooManyActiveLoansError.new)
      return failed
    end

    if user.has_already_borrowed_book?(book)
      add_error(Loans::AlreadyBorrowedBookError.new)
      return failed
    end

    if user.has_overdue_loans?
      add_error(Loans::OverdueLoansError.new)
      return failed
    end

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
  rescue => error
    add_error(error)
    failed
  end
end
