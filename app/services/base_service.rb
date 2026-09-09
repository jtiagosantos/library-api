class BaseService
  def initialize
    @errors = []
  end

  def success(data)
    { data: data, errors: @errors }
  end

  def failed
    { data: nil, errors: @errors }
  end

  def add_error(error)
    @errors << error
  end

  def exists_error?
    @errors.any?
  end
end
