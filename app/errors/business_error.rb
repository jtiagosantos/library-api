class BusinessError < StandardError
  attr_reader :code

  def initialize(message, code: :unprocessable_entity)
    super(message)
    @code = code
  end
end
