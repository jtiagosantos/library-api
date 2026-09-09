class Books::UnavailableBookError < StandardError
  def initialize
    super("Book is unavailable")
  end
end
