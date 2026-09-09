class Books::RegisterBookService < BaseService
  def call(params)
    title = params[:title]
    isbn = params[:isbn]
    total_copies = params[:total_copies]
    available_copies = params[:available_copies]
    description = params[:description]
    published_at = params[:published_at]

    existsBook = Book.exists?(isbn: isbn)

    add_error(Books::IsbnAlreadyRegisteredError.new) if existsBook

    add_error(Books::TotalCopiesCannotBeLessThanZeroError.new) if total_copies <= 0

    add_error(Books::AvailableCopiesCannotBeGreaterThanTotalCopiesError.new) if available_copies > total_copies

    add_error(Books::AvailableCopiesCannotBeNegativeError.new) if available_copies < 0

    return failed if exists_error?

    book = Book.create!(
      title: title,
      isbn: isbn,
      description: description,
      total_copies: total_copies,
      available_copies: available_copies,
      published_at: published_at
    )

    success(book)
  end
end
