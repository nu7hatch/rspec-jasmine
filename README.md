# RSpec::Jasmine

This is a nice and handy, RSpec powered runner and reporter for Jasmine
test suites. It's simpler and more flexible than stuff provided by `jasmine`
gem.

NOTE: It works only with RSpec 2.0 and higher.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-jasmine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-jasmine

## Usage

Check the example folder, it's the simples setup of `rspec-jasmine` together
with dummy Sinatra app. The most important files to check are `spec/jasmine.rb`,
`public/tests.html` and `Rakefile`. To run your tests use rake task:

    $ rake spec:jasmine

You'll get nice output, formatted with your favorite RSpec formatter. 

Probably I should write a generator for this stuff, but so far this is used only
in one project so I'm too lazy for it. If you have spare time you can do so
and send me a pull request. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
