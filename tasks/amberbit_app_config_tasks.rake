namespace :amberbit do
  namespace :config do
    desc "Creates config/application/default.yml and config/application/config.yml files"
    task :setup do
      if File.directory?(File.join(RAILS_ROOT, "config", "application"))
        puts 'Directory config/application already exists, skipping.'
      elsif !File.exists?(File.join(RAILS_ROOT, "config", "application"))
        Dir.mkdir(File.join(RAILS_ROOT, "config", "application"))
        puts "Directory config/application was created."
      else
        puts "AmberBit Config requires config/application to be a directory and it appears to be a regular file!"
        puts "Cannot continue, stopping!"
        exit -1
      end

default_contents = {}
default_contents['default'] = <<BEGIN
# Store your application configuration defaults here. This file should be under
# version control. In case you need installation specific settings please copy
# config.template.yml to config.yml and ignore the latter with your version
# control system.
#
# Usage
# ------
#
# in this file:
# default:
#   application_name: My Super App
#
# development:
#   title_prefix: Development Mode
#
# in your code:
# This is <%= AppConfig['application_name'] %>
#
# or
#
# This is <%= AppConfig.application_name %>
#
default:

development:

test:

staging:

production:

BEGIN

default_contents['config.template'] = <<BEGIN
# See default.yml for usage.
default:

development:

test:

staging:

production:

BEGIN


     %w(default config.template).each do |fn|
       if File.exists?(File.join(RAILS_ROOT, "config", "application", "#{fn}.yml"))
          puts "File config/application/#{fn}.yml already exists, skipping."
       else
          f = File.new(File.join(RAILS_ROOT, "config", "application", "#{fn}.yml"), "w+")
          f.write(default_contents[fn])
          f.close
          puts "File config/application/#{fn}.yml was created."
       end
     end
    end
  end
end
