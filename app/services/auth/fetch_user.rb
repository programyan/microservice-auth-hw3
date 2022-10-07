module Auth
  class FetchUser
    prepend BaseService

    option :uuid

    attr_reader :user

    def call
      return fail!(I18n.t(:forbidden, scope: 'services.auth.fetch_user')) if @uuid.blank? || session.blank?

      @user = session.user
    end

    private

    def session
      @session ||= UserSession.find(uuid: @uuid)
    end
  end
end
