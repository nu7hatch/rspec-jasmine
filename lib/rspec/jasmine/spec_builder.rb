require 'rspec/jasmine/selenium_driver'
require 'rspec/jasmine/example'
require 'json'

module RSpec
  module Jasmine
    class SpecBuilder
      def initialize(world, config = {})
        @world   = world
        @config  = config
        @running = false
      end
  
      def suite
        @config[:suite] || '/tests'
      end
  
      def browser
        @config[:browser] || ENV["JASMINE_BROWSER"] || 'firefox'
      end
  
      def host
        @config[:host] || ENV["JASMINE_HOST"] || 'localhost'
      end
  
      def port
        @config[:port] || ENV["JASMINE_PORT"] || '5001'
      end
  
      def url
        "http://#{host}:#{port}#{suite}"
      end
  
      def start
        @client  = Jasmine::SeleniumDriver.new(browser)
        @running = true
  
        @client.connect(url)
        
        puts "Running test suite with Jasmine against: #{url}"
  
        load_suite_info!
        generate_report!
        wait_for_suites_to_finish
      end
  
      def stop
        @client.disconnect if @running
        @running = false
      end
  
      def wait_for_suites_to_finish
        sleep 0.1 until eval_js('return jsApiReporter.finished')
      end
  
      def eval_js(script)
        @client.eval_js(script)
      end
  
      def load_suite_info!
        started = Time.now
  
        while !eval_js('return jsApiReporter && jsApiReporter.started') do
          raise "couldn't connect to Jasmine after 60 seconds" if (started + 60 < Time.now)
          sleep 0.1
        end
  
        @spec_ids = []
        @spec_results = nil
        @test_suites = eval_js("var result = jsApiReporter.suites(); return JSON.stringify(result)")
      end
  
      def generate_report!
        @test_suites.to_a.each do |suite| 
          declare_suite!(@world, suite)
        end
      end
  
      def declare_suite!(parent, suite)
        me = self
  
        parent.describe suite['name'] do
          suite['children'].each do |suite_or_spec|
            case suite_or_spec["type"]
            when "suite"
              me.declare_suite!(self, suite_or_spec)
            when "spec"
              me.declare_spec!(self, suite_or_spec)
            else
              raise "unknown type #{type} for #{suite_or_spec.inspect}"
            end
          end
        end
      end
  
      def declare_spec!(parent, spec)
        me = self
  
        spec_id = spec['id']
        @spec_ids << spec_id
        
        meta = parent.build_metadata_hash_from([])
        block = proc do
          @result = Jasmine::ExampleResult.new(me.results_for(spec_id))
          Jasmine.failed = true if @result.failed?
        end
  
        parent.examples << Jasmine::Example.new(parent, spec['name'], meta, block)
      end
  
      def json_generate(obj)
        @client.json_generate(obj)
      end
  
      def results_for(spec_id)
        @spec_results ||= load_results
        @spec_results[spec_id.to_s]
      end
  
      def load_results
        @spec_ids.each_slice(50).inject({}) do |results, slice|
          results.merge(eval_js(<<-JS))
            var result = jsApiReporter.resultsForSpecs(#{json_generate(slice)}); 
            return JSON.stringify(result);
          JS
        end
      end
    end
  end
end
