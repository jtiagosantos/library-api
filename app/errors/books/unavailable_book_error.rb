class Books::UnavailableBookError < BusinessError
  def initialize
    super("Book is unavailable", code: :unprocessable_entity)
  end
end
