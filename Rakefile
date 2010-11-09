require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fancy_irb"
    gem.summary = %q{FancyIrb patches your IRB to create a smooth output experience.}
    gem.description = %q{FncyIrb patches your IRB to create a smooth output experience.
* Use fancy colors! You can colorize the prompts, irb errors, +stderr+ and +stdout+
* Output results as Ruby comment #=> (rocket)
* Enhance your output value, using procs}
    gem.email = "mail@janlelis.de"
    gem.homepage = "http://github.com/janlelis/fancy_irb"
    gem.authors = ["Jan Lelis"]
    gem.add_dependency 'wirble'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION').chomp : ""

  rdoc.rdoc_dir = 'doc'
  rdoc.title = "FancyIrb #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
