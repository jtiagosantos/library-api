class Books::UpdateBookService
  def call(params)
    book = Book.find_by(id: params[:id])

    raise EntityNotFoundError.new unless book

    data = { **params.except(:id), **book.attributes.symbolize_keys }

    hash = params.except(:id).deep_symbolize_keys

    p hash

    book = Book.update!(
      params[:id],
      title: data[:title],
      isbn: data[:isbn],
      description: data[:description],
      total_copies: data[:total_copies],
      available_copies: data[:available_copies],
      published_at: data[:published_at]
    )

    book
  end
end
