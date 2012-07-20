require 'rspec/core/example'
require 'jasmine/example_result'
require 'uri'

module RSpec
  module Jasmine
    class Example < RSpec::Core::Example
      def run(example_group_instance, reporter)
        @example_group_instance = example_group_instance
        @example_group_instance.example = self

        start(reporter)

        begin
          unless pending
            begin
              @example_group_instance.instance_eval(&@example_block)
              @result = @example_group_instance.instance_variable_get('@result')
              @result.screem! if @result
            rescue RSpec::Core::Pending::PendingDeclaredInExample => e
              @pending_declared_in_example = e.message
            rescue Exception => e
              set_exception(e)
            end
          end
        rescue Exception => e
          set_exception(e)
        ensure
          @example_group_instance.instance_variables.each do |ivar|
            @example_group_instance.instance_variable_set(ivar, nil)
          end
          @example_group_instance = nil

          begin
            assign_generated_description
          rescue Exception => e
            set_exception(e, "while assigning the example description")
          end
        end
        
        @result.merge_backtrace_with!(exception) if exception
        finish(reporter)
      end
    end
  end
end
