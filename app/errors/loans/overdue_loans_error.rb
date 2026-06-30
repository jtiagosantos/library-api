class Loans::OverdueLoansError < BusinessError
  def initialize
    super("User has overdue loans", code: :unprocessable_entity)
  end
end
