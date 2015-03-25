# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/fancy_irb/version"

Gem::Specification.new do |s|
  s.name        = "fancy_irb"
  s.version     = FancyIrb::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/fancy_irb"
  s.summary     = "FancyIrb makes IRB friendly."
  s.description = "FancyIrb makes IRB # => friendly."
  s.required_ruby_version = '>= 1.9.3'
  s.license = 'MIT'
  s.requirements = ['Windows: ansicon <https://github.com/adoxa/ansicon>']
  s.add_dependency 'paint', '>= 0.9', '< 2.0'
  s.add_dependency 'unicode-display_width', ">= 0.2.0"
  s.add_development_dependency 'rspec', "~> 3.2"
  s.add_development_dependency 'rake', "~> 10.4"
  s.files = [
    "MIT-LICENSE.txt",
    "README.md",
    "Rakefile",
    "CHANGELOG.md",
    "fancy_irb.gemspec",
    "lib/fancy_irb.rb",
    "lib/fancy_irb/irb_ext.rb",
    "lib/fancy_irb/terminal_info.rb",
    "lib/fancy_irb/implementation.rb",
    "lib/fancy_irb/size_detector.rb",
    "lib/fancy_irb/error_capturer.rb",
    "lib/fancy_irb/core_ext.rb",
    "lib/fancy_irb/clean_up.rb",
    "lib/fancy_irb/version.rb",
    "spec/size_detector_spec.rb",
    "spec/fixtures.rb",
  ]
end

