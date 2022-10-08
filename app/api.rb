class Api < Grape::API
  helpers AuthHelper

  format :json
  content_type :json, 'application/json'

  require 'rack/cors'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  rescue_from Grape::Exceptions::ValidationErrors do
    error!({ errors: [{ details: I18n.t(:missing_params, scope: 'api.errors') }] }, 422)
  end

  desc 'Аутентификация' do
    summary 'Эндпоинт проверки сессии пользователя'
    produces ['application/json']
    consumes ['application/json']
  end
  post do
    result = Auth::FetchUser.call(uuid: extracted_token['uuid'])

    if result.success?
      { meta: { user_id: result.user.id } }
    else
      error! ErrorSerializer.from_message(result.errors), 403
    end
  end

  desc 'Логин' do
    summary 'Эндпоинт создания сессии'
    produces ['application/json']
    consumes ['application/json']
  end
  params do
    requires :email, type: String, desc: 'Email'
    requires :password, type: String, desc: 'Пароль'
  end
  post '/login' do
    session_params = Contracts::SessionContract.new.call(declared(params))

    result = UserSessions::Create.call(**session_params.to_h)

    if result.success?
      { meta: { token: JwtEncoder.encode(uuid: result.session.uuid) } }
    else
      error! ErrorSerializer.from_message(result.errors), 401
    end
  end

  desc 'Регистрация' do
    summary 'Эндпоинт создания нового пользователя'
    produces ['application/json']
    consumes ['application/json']
  end
  params do
    requires :email, type: String, desc: 'Email'
    requires :password, type: String, desc: 'Пароль'
    requires :name, type: String, desc: 'Имя'
  end
  post '/signup' do
    user_params = Contracts::UserContract.new.call(declared(params))

    result = Users::Create.call(**user_params.to_h)

    error!(ErrorSerializer.from_model(result.user), 422) if result.failure?
  end

  add_swagger_documentation(
    mount_path: '/swagger/docs',
    info: {
      title: 'Ads API',
      description: 'An API for signing up, login and validate tockens',
      contact_name: 'Andrew Ageev',
      contact_email: 'ageev86@gmail.com',
      license: 'MIT',
      license_url: "https://opensource.org/licenses/MIT",
    }
  )
end