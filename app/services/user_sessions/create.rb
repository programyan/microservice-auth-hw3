module UserSessions
  class Create
    prepend BaseService

    option :email
    option :password
    option :user, default: proc { User.find(email: @email) }, reader: false

    attr_reader :session

    def call
      validate
      create_session unless failure?
    end

    private

    def validate
      return fail_t!(:unauthorized) unless @user&.authenticate(@password)
    end

    def create_session
      @session = UserSession.new(user_id: @user.id)

      return fail!(@session.errors) unless @session.save

      @session
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'services.user_sessions.create'))
    end
  end
end
