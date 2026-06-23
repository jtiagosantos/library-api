class Books::SearchBookByIdService
  def call(id)
    book = Book.find_by(id: id)

    raise EntityNotFoundError.new unless book

    book
  end
end
