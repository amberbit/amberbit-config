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
default_contents['config'] = <<BEGIN
# Store your application configuration defaults here. Values defined here can be easily overwritten by
# assigning them new values in default.yml file.
#
# Usage
# ------
#
# in this file:
# default: My Super App
#
# development:
#   title_prefix: Development Mode
# 
# in ruby:
# This is <%= AppConfig['application_name'] %>
#
default:

development:

test:

production:

BEGIN

default_contents['default'] = <<BEGIN
# See config.yml for usage
default: 

development:

test:

production:

BEGIN


     %w(default config).each do |fn| 
       if File.exists?(File.join(RAILS_ROOT, "config", "application", "#{fn}.yml"))
          puts "File config/application/#{fn}.yml already exists, skipping."
       else 
          f = File.new(File.join(RAILS_ROOT, "config", "application", "#{fn}.yml"), "w+")
          f.close
          puts "File config/application/#{fn}.yml was created."
       end
     end
    end  
  end
end
