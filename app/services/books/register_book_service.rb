class Books::RegisterBookService < BaseService
  def call(input)
    title = input[:title]
    isbn = input[:isbn]
    total_copies = input[:total_copies]
    available_copies = input[:available_copies]
    description = input[:description]
    published_at = input[:published_at]

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
