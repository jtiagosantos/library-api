class Books::IsbnAlreadyRegisteredError < BusinessError
  def initialize
    super("ISBN already registered", code: :conflict)
  end
end
