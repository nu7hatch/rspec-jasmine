module RSpec
  module Jasmine
    class ExampleResult < Hash
      def initialize(results)
        super()
        merge!(results)
      end
  
      def failed?
        self['result'] == 'failed'
      end
  
      def failure
        @failed_message ||= self['messages'].to_a.find { |m| m['passed'] == false }
      end
  
      def error_message
        failure['message'].to_s
      end
  
      def merge_backtrace_with!(e)
        e.instance_variable_set('@stack', self.backtrace)
  
        class << e
          def backtrace
            return @stack
          end
        end
      end
  
      def backtrace
        trace = failure['trace'] || {}
        trace['stack'].to_s.split(/$/).map(&:strip).delete_if do |line|
          line =~ /\/lib\/jasmine-\d+\.\d+\.\d+\/jasmine\.js\:\d+/ || line.strip.empty?
        end
      end
  
      def scream!
        if failed?
          raise RSpec::Expectations::ExpectationNotMetError.new(error_message)
        end
      end
    end
  end
end
