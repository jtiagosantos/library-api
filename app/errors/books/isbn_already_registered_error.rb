class Books::IsbnAlreadyRegisteredError < StandardError
  def initialize
    super("ISBN already registered")
  end
end
