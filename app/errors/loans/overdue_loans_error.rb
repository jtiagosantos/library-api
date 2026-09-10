class Loans::OverdueLoansError < StandardError
  def initialize
    super("User has overdue loans")
  end
end
