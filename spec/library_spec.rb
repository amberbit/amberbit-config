require 'spec/spec_helper'
require 'lib/amberbit-config'

describe AmberBitAppConfig do
  before :each do
    File.open("/tmp/test_default.yml", "w+") do |f|
      f.write "default:\n whatever: testtest"
    end 
  end

  it "should not load any config when just requiring library" do
    defined?(AppConfig).should be_nil
  end

  it "should be possible to specify custom path for configuration files directory" do
    AmberBitAppConfig.initialize("/tmp/test_default.yml", "/tmp/test_config.yml")
    AppConfig.whatever.should eql("testtest")
  end
end

