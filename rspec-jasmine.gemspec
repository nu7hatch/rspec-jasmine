# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec/jasmine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Kowalik"]
  gem.email         = ["chris@nu7hat.ch"]
  gem.homepage      = "http://github.com/nu7hatch/rspec-jasmine"
  gem.description   = %q{Jasmine runner and reporter for RSpec}
  gem.summary       = <<-DOC.strip_heredoc
    This gem provides a neat runner and reporter for Jasmine compatible
    with all the features of RSpec
  DOC

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspec-jasmine"
  gem.require_paths = ["lib"]
  gem.version       = RSpec::Jasmine::VERSION

  gem.add_dependency "rspec", ">= 2.0"
end
