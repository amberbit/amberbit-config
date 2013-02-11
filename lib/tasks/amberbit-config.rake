if defined?(Rails)
  namespace :amberbit do
    namespace :config do
      desc 'Creates config/app_config_default.yml and config/app_config.yml files'
      task :setup do
        if File.directory? Rails.root.join('config')
          puts 'Directory config already exists, skipping.'
        elsif !File.exists?(Rails.root.join('config'))
          Dir.mkdir Rails.root.join('config')
          puts 'Directory config was created.'
        else
          puts 'AmberBit Config requires config to be a directory and it appears to be a regular file!'
          puts 'Cannot continue, stopping!'
          exit(-1)
        end

        %w(app_config_default app_config).each do |fn|
          if File.exists? Rails.root.join('config', "#{fn}.yml")
            puts "File config/#{fn}.yml already exists, skipping."
          else
            File.open Rails.root.join('config', "#{fn}.yml"), 'w+:utf-8' do |file|
              file.write "---\ndefault:\n\ndevelopment:\n\ntest:\n\nstaging:\n\nproduction:"
            end

            puts "File config/#{fn}.yml was created."
          end
        end
      end
    end
  end
end
