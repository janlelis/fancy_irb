# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "fancy_irb"
  s.version     = File.read('VERSION').chomp
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/fancy_irb"
  s.summary     = "FancyIrb patches your IRB to create a smooth output experience."
  s.description = "FancyIrb patches your IRB to create a smooth output experience. You can colorize the prompts, irb errors, stderr and stdout, output your result as #=> (hash rockets) and some other improvements."
  s.required_ruby_version = '>= 1.8.7'
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.license = 'MIT'
  s.requirements = ['Windows: ansicon <https://github.com/adoxa/ansicon>']
  s.add_dependency 'paint', '>= 0.8.1'
  s.add_dependency 'unicode-display_width', ">= 0.1.1"
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

