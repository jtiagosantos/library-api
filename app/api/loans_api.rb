class LoansApi < Api
  resource :loans do
    desc "Lend a book to a user"
    params do
      requires :user_id, type: Integer, desc: "User ID"
      requires :book_id, type: Integer, desc: "Book ID"
    end
    post do
      Loans::LendABookService.new.call(params)
    end
  end
end
