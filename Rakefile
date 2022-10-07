require 'rake'

require_relative 'config/loader'

Loader.init!

namespace :db do
  require 'sequel/core'
  Sequel.extension :migration

  desc 'Create Database'
  task :create do
    db_url = ENV.fetch('DATABASE_URL')
    db_name = db_url.split('/').last
    Sequel.connect(db_url.gsub(db_name, '')) do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"
    end
  end

  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    version = args[:version].to_i if args[:version]
    Loader.connect_to_db! do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)

      Rake::Task['db:dump'].invoke
    end
  end

  desc 'Generate migration'
  task :create_migration, [:name] do |_task, args|
    File.open("db/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{args[:name]}.rb", 'w+') do |file|
      file.write("Sequel.migration do\n  change do\n\n  end\nend\n")
    end
  end

  desc 'Dump schema'
  task :dump do
    Loader.init!
    Loader.connect_to_db! do |db|
      db.extension :schema_dumper
      File.open("db/schema.rb", 'w') {|f| f.write(db.dump_schema_migration) }
    end
  end

  desc 'Seeds'
  task :seeds do
    Loader.load_all!

    require_relative 'db/seeds'
  end
end

desc 'Print routes'
task :routes do
  require_relative 'app/api'
  Api.routes.each do |route|
    method = route.request_method.ljust(10)
    path = route.origin
    puts "     #{method} #{path}"
  end
end

