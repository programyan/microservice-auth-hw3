class User < Sequel::Model
  plugin :secure_password, include_validations: false
  plugin :association_dependencies
  self.raise_on_save_failure = false

  one_to_many :sessions, class: :UserSession

  add_association_dependencies sessions: :delete

  def validate
    super

    validates_presence :name, message: I18n.t(:blank, scope: 'user.errors.name')
    validates_format %r{\A\w+\z}, :name, message: I18n.t(:invalid, scope: 'user.errors.name')
    validates_presence :password, message: I18n.t(:blank, scope: 'user.errors.password') if new?
    validates_presence :email, message: I18n.t(:blank, scope: 'user.errors.email')
    validates_unique :email, message: I18n.t(:uniq, scope: 'user.errors.email')
  end
end