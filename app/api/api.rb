class Api < Grape::API
  version "v1"
  format :json
  prefix "api"

  rescue_from BusinessError do |e|
    error!({ error: e.message, code: e.code }, Rack::Utils::SYMBOL_TO_STATUS_CODE[e.code])
  end

  mount UsersApi
  mount BooksApi
  mount LoansApi
end
