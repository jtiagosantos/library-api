class Books::ListBooksService < BaseService
  def call(params)
    title = params[:title]
    isbn = params[:isbn]
    sort_field = params[:sort_field] || "created_at"
    sort_dir = (params[:sort_dir] || "desc").upcase
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    offset = (page * per_page) - per_page

    books = Book
      .limit(per_page)
      .offset(offset)
      .order("#{sort_field} #{sort_dir}")

    books = books.filter_by_title(title) if title.present?
    books = books.filter_by_isbn(isbn) if isbn.present?

    success(books)
  end
end
