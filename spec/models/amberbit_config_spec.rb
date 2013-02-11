require 'spec_helper'

describe AmberbitConfig do
  it 'should initialize configuration under AppConfig constant' do
    expect(Object).not_to have_constant(:AppConfig)
    AmberbitConfig.initialize app_config_default, app_config
    expect(Object).to have_constant(:AppConfig)
    expect(AppConfig.mailer.method).to be == 'smtp'
  end
end
