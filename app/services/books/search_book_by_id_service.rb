class Books::SearchBookByIdService < BaseService
  def call(id)
    book = Book.find_by(id: id)

    add_error(EntityNotFoundError.new) unless book

    return failed if exists_error?

    success(book)
  end
end
