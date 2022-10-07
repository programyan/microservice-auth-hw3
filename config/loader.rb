require 'bundler/setup'

env = ENV.fetch('RACK_ENV', 'development')

Bundler.require(:default, env)

Dotenv.load(".env.#{env}.local", ".env.#{env}", '.env')

module Loader
  module_function

  def load_all!
    init!
    connect_to_db!
    load_dir('app/helpers/**/*.rb')
    load_file('../app/services/base_service')
    load_dir('app/**/*.rb')
  end

  def connect_to_db!
    block_given? ? Sequel.connect(ENV.fetch('DATABASE_URL')) { |db| yield(db) } : Sequel.connect(ENV.fetch('DATABASE_URL'))
  end

  def init!
    load_dir('config/initializers/**/*.rb')
  end

  def load_file(file_name)
    require_relative file_name
  end

  def load_dir(dir)
    Dir[dir].each do |file_name|
      require_relative "../#{file_name}"
    end
  end
end