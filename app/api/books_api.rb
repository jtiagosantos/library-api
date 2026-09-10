class BooksApi < Api
  helpers ::Helpers::ResponseHelper

  resource :books do
    desc "Register a new book"
    params do
      requires :title, type: String, desc: "Book title"
      requires :isbn, type: String, desc: "Book ISBN"
      optional :description, type: String, desc: "Book description"
      requires :total_copies, type: Integer, desc: "Total number of copies"
      requires :available_copies, type: Integer, desc: "Number of available copies"
      requires :published_at, type: DateTime, desc: "Publication date"
    end
    post "/register" do
      Books::RegisterBookService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data)
    end

    desc "List all registered books"
    get "/" do
      Books::ListBooksService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data)
    end

    desc "Search a book by id"
    params do
      requires :id, type: Integer, desc: "Book ID"
    end
    get "/:id" do
      Books::SearchBookByIdService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors, status=:not_found) if errors.any?

      render_success(data=data)
    end

    desc "Update a book by id"
    params do
      requires :id, type: Integer, desc: "Book ID"
      optional :title, type: String, desc: "Book title"
      optional :isbn, type: String, desc: "Book ISBN"
      optional :description, type: String, desc: "Book description"
      optional :total_copies, type: Integer, desc: "Total number of copies"
      optional :available_copies, type: Integer, desc: "Number of available copies"
      optional :published_at, type: DateTime, desc: "Publication date"
    end
    put "/:id" do
      Books::UpdateBookService.new.call(params) => { data:, errors: }

      return render_failed(errors=errors) if errors.any?

      render_success(data=data)
    end
  end
end
