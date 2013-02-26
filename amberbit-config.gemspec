# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
    s.name = "amberbit-config"
    s.summary = "Yet Another AppConfig for Rails but not only."
    s.description = "Reads YAML files with configuration. Allows you to specify default configuration file you can store in repository and overwrite it with custom configuration file for each application instance and environment."
    s.email = "hubert.lepicki@amberbit.com"
    s.authors = ["Wojciech Piekutowski", "Hubert Lepicki", "Piotr Tynecki", "Leszek Zalewski"]
    s.homepage = "http://github.com/amberbit/amberbit-config"
    s.date = "2013-02-26"
    s.version = "1.2.0"

    s.files = Dir["lib/**/*", "config/**/*"] + ["MIT-LICENSE", "README.rdoc", "VERSION"]
    s.require_path = [".", "lib"]

    s.add_development_dependency "rspec"
    s.add_development_dependency "rspec-rails"
end
