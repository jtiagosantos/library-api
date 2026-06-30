class Loans::TooManyActiveLoansError < BusinessError
  def initialize
    super("User has too many active loans", code: :unprocessable_entity)
  end
end
