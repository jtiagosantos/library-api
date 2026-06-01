class EntityNotFoundError < BusinessError
  def initialize
    super("Entity not found", code: :not_found)
  end
end
