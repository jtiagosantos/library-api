class Books::UpdateBookService < BaseService
  def call(input)
    id = input[:id]

    book = Book.find_by(id: id)

    add_error(EntityNotFoundError.new) unless book

    return failed if exists_error?

    updated_values = { **book.serializable_hash, **input.except(:id) }.symbolize_keys

    return failed if exists_error?

    book.title = updated_values[:title]
    book.isbn = updated_values[:isbn]
    book.description = updated_values[:description]
    book.total_copies = updated_values[:total_copies]
    book.available_copies = updated_values[:available_copies]
    book.published_at = updated_values[:published_at]

    book.save!

    success(book)
  rescue => error
    add_error(error)
    failed
  end
end
