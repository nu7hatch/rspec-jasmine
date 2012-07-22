ENV['RACK_ENV'] == 'test'

$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'rspec'

RSpec.configure do |conf|
end
