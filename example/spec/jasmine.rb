require File.expand_path('../spec_helper', __FILE__)
require 'rspec/jasmine'

config_ru = File.expand_path('../../config.ru', __FILE__)
app, _ = Rack::Builder.parse_file(config_ru)

selected_suites = ENV['SUITES'].split(':') if !!ENV['SUITES']

RSpec::Jasmine::SpecRunner.run(self,
  :app    => app,
  :port   => 3001,
  :suites => selected_suites || %w{/tests.html}
)
