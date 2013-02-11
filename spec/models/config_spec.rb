require 'spec_helper'

describe AmberbitConfig::Config do
  let(:defaults) {{
    'mailer' => {
        'default_url' => 'lvm.me:54544',
        'send_method' => 'test'
      },
      'subdomains' => %w(en ru),
      'test' => 'TEST',
      'default' => 'DEFAULT'
  }}

  let(:customs) {{
    'mailer' => {
      'default_url' => 'example.com',
      'send_method' => 'smtp'
    },
    'subdomains' => %w(en jp),
    'test' => 'TEST',
    'default' => 'DEFAULT'
  }}

  describe 'basic initialization' do
    subject { AmberbitConfig::Config.new(app_config_default, app_config) }

    its(:data) {
      should == {
        'mailer' => {
          'default_url' => 'example.com',
          'send_method' => 'smtp'
        },
        'subdomains' => %w(en jp),
        'test' => 'TEST',
        'default' => 'DEFAULT'
      }
    }

    its(:default) { should == defaults }
    its(:custom)  { should == customs  }
  end

  context 'when some of the configuration is missing' do
    it 'should set one of the present files' do
      c = AmberbitConfig::Config.new '', app_config_default
      expect(c.default).to be_empty
      expect(c.custom).to be == defaults
      expect(c.data).to be == defaults

      c = AmberbitConfig::Config.new app_config_default, empty
      expect(c.default).to be == defaults
      expect(c.custom).to be_empty
      expect(c.data).to be == defaults
    end

    it 'should set an empty hash when no file is present' do
      c = AmberbitConfig::Config.new '', ''
      expect(c.data).to be == {}

      c = AmberbitConfig::Config.new empty, ''
      expect(c.data).to be == {}
    end
  end
end
