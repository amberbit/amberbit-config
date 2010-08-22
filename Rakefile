require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run Specs.'
task :default => :spec

 
desc 'Run specs on the plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.verbose = true
end

desc 'Generate documentation for the amberbit_app_config plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AmberbitAppConfig'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "amberbit-config"
    gemspec.summary = "Yet Another AppConfig for Rails but not only"
    gemspec.description = "Reads YAML files with configuration. Allows you to specify default configuration file you can store in repository and overwrite it with custom configuration file for each application instance and environment."
    gemspec.email = "hubert.lepicki@amberbit.com"
    gemspec.homepage = "http://github.com/amberbit/amberbit-config"
    gemspec.authors = ["Wojciech Piekutowski", "Hubert Lepicki"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
