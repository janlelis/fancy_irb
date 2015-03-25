require 'rubygems'
require 'rake'
require 'fileutils'

def gemspec
  @gemspec ||= eval(File.read('fancy_irb.gemspec'), binding, 'fancy_irb.gemspec')
end

desc "Build the gem"
task :gem => :gemspec do
  sh "gem build fancy_irb.gemspec"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
end

desc "Install the gem locally (without docs)"
task :install => :gem do
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}.gem --no-rdoc --no-ri --local}
end

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

# RSpec Task
desc("Run specs"); task(:spec){sh "rspec"}; task(default: :spec)
