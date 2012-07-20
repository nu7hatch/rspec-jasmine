require 'rspec/jasmine/spec_builder'
require 'rack'
require 'rack/server'

module RSpec
  module Jasmine
    class SpecRunner
      def self.run(world, options = {})
        suites = options[:suites] || ENV['JASMINE_SUITES'].to_s.split(':')
        return if suites.empty?
  
        builders = suites.map do |suite|
          RSpec::Jasmine::SpecBuilder.new(world, options.merge(:suite => suite))
        end
        
        first_builder = builders.first
        
        Thread.new do
          Rack::Server.new({
            :app       => options[:app],
            :Port      => first_builder.port,
            :Host      => first_builder.host,
          }).start { |s| s.silent = true }
        end
  
        require 'rspec/core/runner'
  
        builders.each_with_index do |builder, id|
          RSpec.configuration.after(:suite) do
            builder.stop
          end
  
          puts if id > 0
          builder.start
          RSpec::Core::Runner.run([])
        end
  
        if Jasmine.failed
          exit(1)
        end
      end
    end
  end
end
