class EntityNotFoundError < StandardError
  def initialize
    super("Entity not found")
  end
end
