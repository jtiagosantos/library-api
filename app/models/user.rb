class User < ApplicationRecord
  enum :status, { active: "active", blocked: "blocked" }
end
