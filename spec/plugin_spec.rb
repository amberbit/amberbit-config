require 'spec/spec_helper'
require 'lib/amber_bit_app_config.rb'

describe AmberBitAppConfig do
  it "should load initial config on Rails startup" do
    require File.expand_path(File.dirname(__FILE__) + "/testapp/config/environment")
    require 'spec/rails'
    AppConfig.should_not be_nil   
  end
 
  it "should load values from default.yml" do
    AppConfig['app'].should be_instance_of(HashStruct)
    AppConfig['app']['name'].should eql("MyApp")
    AppConfig.app.name.should eql("MyApp")
  end

  it "should overwrite values defined in default.yml by values defined in config.yml" do
    AppConfig['current_file_name'].should eql("config.yml")
    AppConfig.current_file_name.should eql("config.yml")
  end

  it "should overwrite values defined in default.yml by values defined in config.yml in nested keys" do
    AppConfig.app.url.should eql("http://myapp.localhost")
  end
 
  it "should overwrite values defined in default section by values from current enviromnent section" do
    AppConfig['current_env'].should eql("test")
    AppConfig.current_env.should eql("test")
  end
end

