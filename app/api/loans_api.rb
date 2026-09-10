class LoansApi < Api
  helpers ::Helpers::ResponseHelper

  resource :loans do
    desc "Lend a book to a user"
    params do
      requires :user_id, type: Integer, desc: "User ID"
      requires :book_id, type: Integer, desc: "Book ID"
    end
    post do
      Loans::LendABookService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data, status=:created)
    end

    desc "List all loans"
    get do
      Loans::ListLoansService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data)
    end

    desc "Return a book"
    params do
      requires :id, type: Integer, desc: "Loan ID"
    end
    patch "/:id/return" do
      Loans::ReturnBookService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data)
    end

    desc "Search a loan by ID"
    params do
      requires :id, type: Integer, desc: "Loan ID"
    end
    get "/:id" do
      Loans::SearchLoanByIdService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data, status=:not_found)
    end
  end
end
