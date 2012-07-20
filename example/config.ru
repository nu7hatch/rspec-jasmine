require 'sinatra'

set :public_folder, File.expand_path('../public', __FILE__)

run Sinatra::Application