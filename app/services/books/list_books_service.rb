class Books::ListBooksService
  def call(params)
    title = params[:title]
    isbn = params[:isbn]
    sort_field = params[:sort_field] || "created_at"
    sort_dir = (params[:sort_dir] || "desc").upcase

    books = Book.order("#{sort_field} #{sort_dir}")

    books = books.filter_by_title(title) if title.present?
    books = books.filter_by_isbn(isbn) if isbn.present?

    books
  end
end
