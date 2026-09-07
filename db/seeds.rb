# frozen_string_literal: true

# =============================================================================
# Seed: Users, Books & Loans
# Run with: bin/rails db:seed
# Idempotent – safe to run multiple times (uses find_or_create_by!)
# =============================================================================

puts "Seeding users..."

users = [
  { username: "Alice Santos",   email: "alice@example.com",   status: "active" },
  { username: "Bruno Lima",     email: "bruno@example.com",   status: "active" },
  { username: "Carla Mendes",   email: "carla@example.com",   status: "active" },
  { username: "Daniel Rocha",   email: "daniel@example.com",  status: "active" },
  { username: "Elena Martins",  email: "elena@example.com",   status: "blocked" }
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.username = attrs[:username]
    u.status   = attrs[:status]
  end
end

puts "  #{users.size} users ready."

# -----------------------------------------------------------------------------

puts "Seeding books..."

books_data = [
  {
    title: "Domain-Driven Design",
    isbn: "978-0-321-12521-7",
    description: "Tackling complexity in the heart of software.",
    total_copies: 3,
    available_copies: 3,
    published_at: Date.new(2003, 8, 22)
  },
  {
    title: "Clean Code",
    isbn: "978-0-132-35088-4",
    description: "A handbook of agile software craftsmanship.",
    total_copies: 5,
    available_copies: 5,
    published_at: Date.new(2008, 8, 1)
  },
  {
    title: "Refactoring",
    isbn: "978-0-201-48567-7",
    description: "Improving the design of existing code.",
    total_copies: 2,
    available_copies: 2,
    published_at: Date.new(1999, 7, 8)
  },
  {
    title: "The Pragmatic Programmer",
    isbn: "978-0-135-95705-9",
    description: "Your journey to mastery.",
    total_copies: 4,
    available_copies: 4,
    published_at: Date.new(2019, 9, 23)
  },
  {
    title: "Design Patterns",
    isbn: "978-0-201-63361-0",
    description: "Elements of reusable object-oriented software.",
    total_copies: 3,
    available_copies: 3,
    published_at: Date.new(1994, 10, 31)
  },
  {
    title: "Eloquent Ruby",
    isbn: "978-0-321-58410-6",
    description: "The Ruby way of writing code.",
    total_copies: 2,
    available_copies: 2,
    published_at: Date.new(2011, 2, 21)
  }
]

books = books_data.map do |attrs|
  Book.find_or_create_by!(isbn: attrs[:isbn]) do |b|
    b.title            = attrs[:title]
    b.description      = attrs[:description]
    b.total_copies     = attrs[:total_copies]
    b.available_copies = attrs[:available_copies]
    b.published_at     = attrs[:published_at]
  end
end

puts "  #{books.size} books ready."

# -----------------------------------------------------------------------------

puts "Seeding loans..."

alice, bruno, carla, daniel = users[0], users[1], users[2], users[3]
ddd, clean_code, refactoring, pragmatic, design_patterns, eloquent_ruby = *books

now = Time.current
loans_created = 0

# Helper – idempotent by (user, book, status). Adjusts available_copies only
# when a NEW active/overdue loan is inserted.
create_loan = lambda do |attrs|
  loan = Loan.find_or_create_by!(
    user: attrs[:user],
    book: attrs[:book],
    status: attrs[:status]
  ) do |l|
    l.borrowed_at = attrs[:borrowed_at]
    l.due_date    = attrs[:due_date]
    l.returned_at = attrs[:returned_at]
  end

  if loan.previously_new_record? && loan.returned_at.nil?
    loan.book.decrement!(:available_copies)
  end

  loans_created += 1
  loan
end

# -- 1) Active loans (normal, not overdue) ------------------------------------

# Alice borrowed "Clean Code" 3 days ago (due in 4 days)
create_loan.call(
  user: alice, book: clean_code,
  borrowed_at: now - 3.days,
  due_date: now + 4.days,
  returned_at: nil,
  status: "active"
)

# Bruno borrowed "The Pragmatic Programmer" 1 day ago (due in 6 days)
create_loan.call(
  user: bruno, book: pragmatic,
  borrowed_at: now - 1.day,
  due_date: now + 6.days,
  returned_at: nil,
  status: "active"
)

# Carla borrowed "Eloquent Ruby" 2 days ago (due in 5 days)
create_loan.call(
  user: carla, book: eloquent_ruby,
  borrowed_at: now - 2.days,
  due_date: now + 5.days,
  returned_at: nil,
  status: "active"
)

# -- 2) Overdue but still "active" (scheduler hasn't run yet) -----------------

# Daniel borrowed "Refactoring" 9 days ago, was due 2 days ago – NOT returned, still active
create_loan.call(
  user: daniel, book: refactoring,
  borrowed_at: now - 9.days,
  due_date: now - 2.days,
  returned_at: nil,
  status: "active"
)

# Carla borrowed "Design Patterns" 8 days ago, was due 1 day ago – NOT returned, still active
create_loan.call(
  user: carla, book: design_patterns,
  borrowed_at: now - 8.days,
  due_date: now - 1.day,
  returned_at: nil,
  status: "active"
)

# -- 3) Overdue loans (already marked by scheduler) ---------------------------

# Alice borrowed "DDD" 15 days ago, was due 8 days ago – NOT returned
create_loan.call(
  user: alice, book: ddd,
  borrowed_at: now - 15.days,
  due_date: now - 8.days,
  returned_at: nil,
  status: "overdue"
)

# Bruno borrowed "Design Patterns" 10 days ago, was due 3 days ago – NOT returned
create_loan.call(
  user: bruno, book: design_patterns,
  borrowed_at: now - 10.days,
  due_date: now - 3.days,
  returned_at: nil,
  status: "overdue"
)

# -- 4) Returned loans --------------------------------------------------------

# Alice had borrowed "Refactoring" and already returned it
create_loan.call(
  user: alice, book: refactoring,
  borrowed_at: now - 30.days,
  due_date: now - 23.days,
  returned_at: now - 25.days,
  status: "returned"
)

# Carla had borrowed "DDD" and already returned it
create_loan.call(
  user: carla, book: ddd,
  borrowed_at: now - 14.days,
  due_date: now - 7.days,
  returned_at: now - 8.days,
  status: "returned"
)

# Daniel had borrowed "Clean Code" and already returned it
create_loan.call(
  user: daniel, book: clean_code,
  borrowed_at: now - 12.days,
  due_date: now - 5.days,
  returned_at: now - 6.days,
  status: "returned"
)

puts "  #{loans_created} loans ready."

# -----------------------------------------------------------------------------

active_but_overdue = Loan.active.where("due_date < ?", now).count

puts ""
puts "Seed complete!"
puts "  Users:  #{User.count}"
puts "  Books:  #{Book.count}"
puts "  Loans:  #{Loan.count}"
puts "    - active:             #{Loan.active.count} (#{active_but_overdue} past due date, pending scheduler)"
puts "    - overdue:            #{Loan.overdue.count}"
puts "    - returned:           #{Loan.returned.count}"
