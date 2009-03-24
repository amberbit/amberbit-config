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
