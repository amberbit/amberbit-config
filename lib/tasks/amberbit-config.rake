namespace :amberbit do
    namespace :config do
        desc "Creates config/app_config_default.yml and config/app_config.yml files"
        task :setup do
            if File.directory?(File.join(Rails.root, "config"))
                puts "Directory config already exists, skipping."
            elsif !File.exists?(File.join(Rails.root, "config"))
                Dir.mkdir(File.join(Rails.root, "config"))
                puts "Directory config was created."
            else
                puts "AmberBit Config requires config to be a directory and it appears to be a regular file!"
                puts "Cannot continue, stopping!"
                exit -1
            end

            default_contents = {}
            default_contents["app_config_default"] = "default:\n\ndevelopment:\n\ntest:\n\nstaging:\n\nproduction:"
            default_contents["app_config"] = "default:\n\ndevelopment:\n\ntest:\n\nstaging:\n\nproduction:"

            %w(app_config_default app_config).each do |fn|
                if File.exists?(File.join(Rails.root, "config", "#{fn}.yml"))
                    puts "File config/#{fn}.yml already exists, skipping."
                else
                    f = File.new(File.join(Rails.root, "config", "#{fn}.yml"), "w+")
                    f.write(default_contents[fn])
                    f.close
                    puts "File config/#{fn}.yml was created."
                end
            end
        end
    end
end
