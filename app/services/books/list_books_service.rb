class Books::ListBooksService
  def call(params)
    title = params[:title]
    isbn = params[:isbn]
    books = Book.all

    books = books.filter_by_title(title) if title.present?
    books = books.filter_by_isbn(isbn) if isbn.present?

    books
  end
end
