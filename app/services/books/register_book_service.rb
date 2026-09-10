class Books::RegisterBookService < BaseService
  def call(input)
    title = input[:title]
    isbn = input[:isbn]
    total_copies = input[:total_copies]
    available_copies = input[:available_copies]
    description = input[:description]
    published_at = input[:published_at]

    book = Book.create!(
      title: title,
      isbn: isbn,
      description: description,
      total_copies: total_copies,
      available_copies: available_copies,
      published_at: published_at
    )

    success(book)
  rescue => error
    add_error(error)
    failed
  end
end
