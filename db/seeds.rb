# frozen_string_literal: true

# =============================================================================
# Seed: Users, Books & Loans
# Run with: bin/rails db:seed
# Generates a large dataset for pagination testing using Faker.
# Re-runnable – clears existing data before inserting.
# =============================================================================

require "faker"

Faker::Config.locale = "pt-BR"
SEED_RANDOM = Random.new(42)
Faker::Config.random = SEED_RANDOM

NOW = Time.current

# Clear everything in dependency order
puts "Cleaning existing data..."
Loan.delete_all
Book.delete_all
User.delete_all

# =============================================================================
# Users (20)
# =============================================================================

puts "Seeding users..."

users = 20.times.map do |i|
  User.create!(
    email:    "user#{i + 1}@example.com",
    username: Faker::Name.unique.name,
    status:   i < 17 ? "active" : "blocked"
  )
end

puts "  #{users.size} users ready."

# =============================================================================
# Books (100) – with created_at spread over the last 12 months
# =============================================================================

puts "Seeding books..."

# Time buckets so books are distributed across different periods
TIME_BUCKETS = [
  { range: (10.months.ago..8.months.ago), weight: 10 },
  { range: (8.months.ago..6.months.ago),  weight: 15 },
  { range: (6.months.ago..4.months.ago),  weight: 15 },
  { range: (4.months.ago..2.months.ago),  weight: 20 },
  { range: (2.months.ago..1.month.ago),   weight: 20 },
  { range: (1.month.ago..NOW),            weight: 20 }
].freeze

def random_time_in(range)
  from = range.first.to_f
  to   = range.last.to_f
  Time.zone.at(SEED_RANDOM.rand(from..to))
end

# Build a flat list of time slots weighted by the `weight` field
time_slots = TIME_BUCKETS.flat_map do |bucket|
  Array.new(bucket[:weight]) { bucket[:range] }
end

books = 100.times.map do |i|
  slot_range   = time_slots[i % time_slots.size]
  created      = random_time_in(slot_range)
  total_copies = SEED_RANDOM.rand(1..10)

  book = Book.create!(
    isbn:             Faker::Barcode.unique.isbn,
    title:            Faker::Book.unique.title,
    description:      Faker::Lorem.sentence(word_count: SEED_RANDOM.rand(8..20)),
    total_copies:     total_copies,
    available_copies: total_copies,
    published_at:     Faker::Date.between(from: Date.new(1970, 1, 1), to: Date.today)
  )

  book.update_columns(created_at: created, updated_at: created)
  book
end

puts "  #{books.size} books ready."

# =============================================================================
# Loans (200) – mixed statuses with realistic dates
# =============================================================================

puts "Seeding loans..."

active_users = users.select { |u| u.status == "active" }
loans_created = 0

create_loan = lambda do |attrs|
  loan = Loan.create!(
    user:        attrs[:user],
    book:        attrs[:book],
    borrowed_at: attrs[:borrowed_at],
    due_date:    attrs[:due_date],
    returned_at: attrs[:returned_at],
    status:      attrs[:status]
  )

  if loan.returned_at.nil?
    loan.book.decrement!(:available_copies) if loan.book.available_copies.positive?
  end

  loans_created += 1
  loan
end

200.times do
  user = active_users.sample(random: SEED_RANDOM)
  book = books.sample(random: SEED_RANDOM)

  scenario = SEED_RANDOM.rand(100)

  case scenario
  when 0..49 # 50% – returned
    borrowed_at = Faker::Time.between(from: 6.months.ago, to: 2.weeks.ago)
    due_date    = borrowed_at + SEED_RANDOM.rand(7..21).days
    returned_at = borrowed_at + SEED_RANDOM.rand(3..18).days

    create_loan.call(
      user: user, book: book,
      borrowed_at: borrowed_at,
      due_date: due_date,
      returned_at: returned_at,
      status: "returned"
    )
  when 50..74 # 25% – active (not overdue)
    borrowed_at = Faker::Time.between(from: 5.days.ago, to: 1.day.ago)
    due_date    = NOW + SEED_RANDOM.rand(2..14).days

    create_loan.call(
      user: user, book: book,
      borrowed_at: borrowed_at,
      due_date: due_date,
      returned_at: nil,
      status: "active"
    )
  when 75..89 # 15% – active but past due (scheduler hasn't run)
    borrowed_at = Faker::Time.between(from: 30.days.ago, to: 10.days.ago)
    due_date    = borrowed_at + SEED_RANDOM.rand(5..10).days

    create_loan.call(
      user: user, book: book,
      borrowed_at: borrowed_at,
      due_date: [due_date, NOW - 1.day].min, # ensure past due
      returned_at: nil,
      status: "active"
    )
  else # 10% – overdue (already marked)
    borrowed_at = Faker::Time.between(from: 60.days.ago, to: 20.days.ago)
    due_date    = borrowed_at + SEED_RANDOM.rand(5..14).days

    create_loan.call(
      user: user, book: book,
      borrowed_at: borrowed_at,
      due_date: [due_date, NOW - 3.days].min,
      returned_at: nil,
      status: "overdue"
    )
  end
end

puts "  #{loans_created} loans ready."

# =============================================================================
# Summary
# =============================================================================

active_but_overdue = Loan.active.where("due_date < ?", NOW).count

puts ""
puts "Seed complete!"
puts "  Users:  #{User.count}"
puts "  Books:  #{Book.count}"
puts "  Loans:  #{Loan.count}"
puts "    - active:   #{Loan.active.count} (#{active_but_overdue} past due date, pending scheduler)"
puts "    - overdue:  #{Loan.overdue.count}"
puts "    - returned: #{Loan.returned.count}"
