require 'rspec/jasmine/spec_runner'

module RSpec
  module Jasmine
    class << self
      attr_accessor :failed
    end
  end
end
