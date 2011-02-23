# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
 
Gem::Specification.new do |s|
  s.name        = "fancy_irb"
  s.version     = File.exist?('VERSION') ? File.read('VERSION').chomp : ""
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/fancy_irb"
  s.summary     = "FancyIrb patches your IRB to create a smooth output experience."
  s.description = "FancyIrb patches your IRB to create a smooth output experience. You can colorize the prompts, irb errors, stderr and stdout. Results can be putted as #=> (rocket). Furthermore, it's possible to apply filter procs to your output value."
  s.required_rubygems_version = '>= 1.3.6'
  s.required_ruby_version     = '>= 1.8.7'
  #s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.license = 'MIT'
  s.requirements = ['On Windows, you need ansicon: https://github.com/adoxa/ansicon']
  s.add_dependency('wirb', '>= 0.2.4')
  s.add_dependency('unicode-display_width', ">= 0.1.1")
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "CHANGELOG.rdoc",
    "fancy_irb.gemspec",
    "lib/fancy_irb.rb",
    "lib/fancy_irb/irb_ext.rb"
  ]
end

