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

now = Time.current

books_data = [
  # -- Registered 12 months ago --------------------------------------------------
  {
    title: "Domain-Driven Design",
    isbn: "978-0-321-12521-7",
    description: "Tackling complexity in the heart of software.",
    total_copies: 3,
    available_copies: 3,
    published_at: Date.new(2003, 8, 22),
    created_at: now - 12.months
  },
  {
    title: "Design Patterns",
    isbn: "978-0-201-63361-0",
    description: "Elements of reusable object-oriented software.",
    total_copies: 3,
    available_copies: 3,
    published_at: Date.new(1994, 10, 31),
    created_at: now - 12.months
  },
  # -- Registered 6 months ago ---------------------------------------------------
  {
    title: "Clean Code",
    isbn: "978-0-132-35088-4",
    description: "A handbook of agile software craftsmanship.",
    total_copies: 5,
    available_copies: 5,
    published_at: Date.new(2008, 8, 1),
    created_at: now - 6.months
  },
  {
    title: "Refactoring",
    isbn: "978-0-201-48567-7",
    description: "Improving the design of existing code.",
    total_copies: 2,
    available_copies: 2,
    published_at: Date.new(1999, 7, 8),
    created_at: now - 6.months
  },
  # -- Registered 3 months ago ---------------------------------------------------
  {
    title: "The Pragmatic Programmer",
    isbn: "978-0-135-95705-9",
    description: "Your journey to mastery.",
    total_copies: 4,
    available_copies: 4,
    published_at: Date.new(2019, 9, 23),
    created_at: now - 3.months
  },
  {
    title: "Eloquent Ruby",
    isbn: "978-0-321-58410-6",
    description: "The Ruby way of writing code.",
    total_copies: 2,
    available_copies: 2,
    published_at: Date.new(2011, 2, 21),
    created_at: now - 3.months
  },
  # -- Registered 1 month ago ----------------------------------------------------
  {
    title: "Practical Object-Oriented Design in Ruby",
    isbn: "978-0-321-72133-4",
    description: "An agile primer on object-oriented design.",
    total_copies: 3,
    available_copies: 3,
    published_at: Date.new(2012, 9, 5),
    created_at: now - 1.month
  },
  {
    title: "Clean Architecture",
    isbn: "978-0-134-49416-6",
    description: "A craftsman's guide to software structure and design.",
    total_copies: 4,
    available_copies: 4,
    published_at: Date.new(2017, 9, 10),
    created_at: now - 1.month
  },
  # -- Registered 2 weeks ago ----------------------------------------------------
  {
    title: "Metaprogramming Ruby 2",
    isbn: "978-1-941-22212-6",
    description: "Program like the Ruby pros.",
    total_copies: 2,
    available_copies: 2,
    published_at: Date.new(2014, 8, 29),
    created_at: now - 2.weeks
  },
  {
    title: "Working Effectively with Legacy Code",
    isbn: "978-0-131-17754-1",
    description: "Strategies for working with large, untested code bases.",
    total_copies: 3,
    available_copies: 3,
    published_at: Date.new(2004, 9, 22),
    created_at: now - 2.weeks
  },
  # -- Registered 3 days ago -----------------------------------------------------
  {
    title: "Agile Web Development with Rails 7",
    isbn: "978-1-680-50954-9",
    description: "A pragmatic guide to modern Rails development.",
    total_copies: 5,
    available_copies: 5,
    published_at: Date.new(2023, 4, 15),
    created_at: now - 3.days
  },
  # -- Registered today ----------------------------------------------------------
  {
    title: "Ruby Under a Microscope",
    isbn: "978-1-593-27527-3",
    description: "An illustrated guide to Ruby internals.",
    total_copies: 2,
    available_copies: 2,
    published_at: Date.new(2013, 11, 15),
    created_at: now
  }
]

books = books_data.map do |attrs|
  custom_created_at = attrs.delete(:created_at)

  book = Book.find_or_create_by!(isbn: attrs[:isbn]) do |b|
    b.title            = attrs[:title]
    b.description      = attrs[:description]
    b.total_copies     = attrs[:total_copies]
    b.available_copies = attrs[:available_copies]
    b.published_at     = attrs[:published_at]
  end

  book.update_columns(created_at: custom_created_at, updated_at: custom_created_at)
  book
end

puts "  #{books.size} books ready."

# -----------------------------------------------------------------------------

puts "Seeding loans..."

alice, bruno, carla, daniel = users[0], users[1], users[2], users[3]

books_by_isbn = books.index_by(&:isbn)
ddd              = books_by_isbn["978-0-321-12521-7"]
design_patterns  = books_by_isbn["978-0-201-63361-0"]
clean_code       = books_by_isbn["978-0-132-35088-4"]
refactoring      = books_by_isbn["978-0-201-48567-7"]
pragmatic        = books_by_isbn["978-0-135-95705-9"]
eloquent_ruby    = books_by_isbn["978-0-321-58410-6"]

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
