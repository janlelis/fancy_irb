# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/fancy_irb/version"

Gem::Specification.new do |s|
  s.name        = "fancy_irb"
  s.version     = FancyIrb::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/fancy_irb"
  s.summary     = "FancyIrb patches your IRB to create a smooth output experience."
  s.description = "FancyIrb patches your IRB to create a smooth output experience. You can colorize the prompts, irb errors, stderr and stdout, output your result as #=> (hash rockets) and some other improvements."
  s.required_ruby_version = '~> 2.0'
  s.license = 'MIT'
  s.requirements = ['Windows: ansicon <https://github.com/adoxa/ansicon>']
  s.add_dependency 'paint', '>= 0.9.0'
  s.add_dependency 'unicode-display_width', ">= 0.2.0"
  s.files = [
    "MIT-LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "CHANGELOG.rdoc",
    "fancy_irb.gemspec",
    "lib/fancy_irb.rb",
    "lib/fancy_irb/irb_ext.rb",
    "lib/fancy_irb/terminal_info.rb",
    "lib/fancy_irb/implementation.rb",
    "lib/fancy_irb/core_ext.rb",
    "lib/fancy_irb/stream_ext.rb",
    "lib/fancy_irb/clean_up.rb",
    "lib/fancy_irb/version.rb",
  ]
end

