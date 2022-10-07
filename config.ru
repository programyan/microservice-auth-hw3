require_relative './config/loader'

Loader.load_all!

Api.compile!

run Api