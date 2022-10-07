module Users
  class Create
    prepend BaseService

    option :name
    option :email
    option :password

    attr_reader :user

    def call
      @user = User.new(
        name: @name,
        email: @email,
        password: @password
      )

      fail!(@user.errors) unless @user.save
    end
  end
end