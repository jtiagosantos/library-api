class BooksApi < Api
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
      Books::RegisterBookService.new.call(params)
    end

    desc "List all registered books"
    get "/" do
      Books::ListBooksService.new.call
    end

    desc "Search a book by id"
    params do
      requires :id, type: Integer, desc: "Book ID"
    end
    get "/:id" do
      Books::SearchBookByIdService.new.call(params[:id])
    end
  end
end
