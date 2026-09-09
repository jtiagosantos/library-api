module Helpers::ResponseHelper
  def render_success(data, status = :ok, metadata = {})
    response = {
      data: data,
      errors: [],
      metadata: metadata
    }

    status status

    present(response)
  end

  def render_failed(errors, status = :unprocessable_content, metadata = {})
    response = {
      data: nil,
      errors: errors,
      metadata: metadata
    }

    status status

    present(response)
  end
end
