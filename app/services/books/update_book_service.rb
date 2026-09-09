class Books::UpdateBookService < BaseService
  def call(params)
    id = params[:id]

    book = Book.find_by(id: id)

    add_error(EntityNotFoundError.new) unless book

    return failed if exists_error?

    updated_values = { **book.serializable_hash, **params.except(:id) }.symbolize_keys

    total_copies = updated_values[:total_copies]
    available_copies = updated_values[:available_copies]

    add_error(Books::TotalCopiesCannotBeLessThanZeroError.new) if total_copies <= 0

    add_error(Books::AvailableCopiesCannotBeGreaterThanTotalCopiesError.new) if available_copies > total_copies

    add_error(Books::AvailableCopiesCannotBeNegativeError.new) if available_copies < 0

    return failed if exists_error?

    book.title = updated_values[:title]
    book.isbn = updated_values[:isbn]
    book.description = updated_values[:description]
    book.total_copies = updated_values[:total_copies]
    book.available_copies = updated_values[:available_copies]
    book.published_at = updated_values[:published_at]

    book.save!

    success(book)
  end
end
