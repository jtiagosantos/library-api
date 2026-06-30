class Books::RegisterBookService
  def call(params)
    existsBook = Book.exists?(isbn: params[:isbn])

    raise Books::IsbnAlreadyRegisteredError.new if existsBook

    raise Books::TotalCopiesCannotBeLessThanZeroError.new if params[:total_copies] <= 0

    raise Books::AvailableCopiesCannotBeGreaterThanTotalCopiesError.new if params[:available_copies] > params[:total_copies]

    raise Books::AvailableCopiesCannotBeNegativeError.new if params[:available_copies] < 0

    Book.create!(
      title: params[:title],
      isbn: params[:isbn],
      description: params[:description],
      total_copies: params[:total_copies],
      available_copies: params[:available_copies],
      published_at: params[:published_at]
    )
  end
end
