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

Create a `spec/jasmine.rb` file and copy following content there (yeah, i'm
too lazy to write a generator for this, feel free to make one and send
me a pull request...):

    require File.expand_path('../spec_helper', __FILE__)
    require 'rspec/jasmine'
    
    config_ru = File.expand_path('../../config.ru', __FILE__)
    app, _ = Rack::Builder.parse_file(config_ru)
    selected_suites = ENV['SUITES'].split(':') if !!ENV['SUITES']
    
    Jasmine::SpecRunner.run(self,
      :app    => app,
      :port   => 3001,
      :suites => selected_suites || %w{/tests.html}
    )

Now download [latest version Jasmine](https://github.com/pivotal/jasmine/downloads)
unpack it and place `/lib` folder directly in your public directory. When you
are done, create a tests suite runner file - an html file which ties all this
stuff together, here's an example one (let's say `public/tests.html`):

    <!DOCTYPE html>
    <html>
    <head>
      <title>Jasmine Spec Runner</title>
    
      <link rel="shortcut icon" type="image/png" href="/lib/jasmine-1.2.0/jasmine_favicon.png">
      <link rel="stylesheet" type="text/css" href="/lib/jasmine-1.2.0/jasmine.css">
    
      <!-- Jasmine lib files -->
      <script type="text/javascript" src="/lib/jasmine-1.2.0/jasmine.js"></script>
      <script type="text/javascript" src="/lib/jasmine-1.2.0/jasmine-html.js"></script>
    
      <!-- 
        Your spec files - can be all the scripts separately, or some
        nicely combined together with asset pipeline, etc.
      -->
      <script type="text/javascript" src="/assets/specs.js"></script>
    
      <!-- Jasmine suite runner -->
      <script type="text/javascript">
      
        var jsApiReporter;
        
        (function() {
            var jasmineEnv = jasmine.getEnv();
            jasmineEnv.updateInterval = 1000;
        
            jsApiReporter = new jasmine.JsApiReporter();
            var htmlReporter = new jasmine.HtmlReporter();
        
            jasmineEnv.addReporter(jsApiReporter);
            jasmineEnv.addReporter(htmlReporter);
        
            jasmineEnv.specFilter = function(spec) {
                return htmlReporter.specFilter(spec);
            };
        
            var currentWindowOnload = window.onload;
        
            window.onload = function() {
                if (currentWindowOnload) {
                    currentWindowOnload();
                }
                execJasmine();
            };
        
            function execJasmine() {
                jasmineEnv.execute();
            }
        })();
      
      </script>
    </head>
    <body>
    </body>
    </html>

Last thing to do, add following rake task to your `Rakefile`:

    namespace :spec do
      desc "Runs jasmine specs"
      task :jasmine do
        require File.expand_path('../spec/jasmine', __FILE__)
      end
    end

Yeap, we're done. Now you can run your Jasmine test suites with
rake command:

    $ rake spec:jasmine

You'll get nice output, formatted with your favorite RSpec formatter. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
