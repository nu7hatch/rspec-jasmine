require 'selenium-webdriver'
require 'enumerator'

module RSpec
  module Jasmine
    class SeleniumDriver
      attr_reader :options, :browser, :address
  
      def initialize(browser, options = {})
        @options = options
        @browser = browser
      end
  
      def selenium_server
        @selenium_server = if ENV['SELENIUM_SERVER']
          ENV['SELENIUM_SERVER']
        elsif ENV['SELENIUM_SERVER_PORT']
          "http://localhost:#{ENV['SELENIUM_SERVER_PORT']}/wd/hub"
        end
      end
  
      def driver
        @driver ||= if selenium_server
          Selenium::WebDriver.for :remote, :url => selenium_server, :desired_capabilities => browser.to_sym
        else
          Selenium::WebDriver.for browser.to_sym, options
        end
      end
  
      def tests_finished?
        x("return jsApiReporter.finished") == 'true'
      end
  
      def connect(address)
        driver.navigate.to(address)
      end
  
      def disconnect
        driver.quit
      end
  
      def eval_js(script)
        result = x(script)
        JSON.parse("{\"result\":#{result}}", :max_nesting => false)["result"]
      end
  
      def json_generate(obj)
        JSON.generate(obj)
      end
  
      def x(script)
        driver.execute_script(script)
      end
    end
  end
end
