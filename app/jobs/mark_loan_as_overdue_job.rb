class MarkLoanAsOverdueJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Started execution of #{self.class.name}"
    Loans::MarkLoanAsOverdueService.new.call
    puts "Finished execution of #{self.class.name}"
  end
end
