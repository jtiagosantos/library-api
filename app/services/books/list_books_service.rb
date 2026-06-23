class Books::ListBooksService
  def call
    Book.all
  end
end
