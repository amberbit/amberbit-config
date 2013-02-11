require 'spec_helper'

describe AmberbitConfig::HashStruct, 'OpenStruct alike object which also provide access to variables via hash operator' do
  describe 'basic hash/open struct' do
    subject { AmberbitConfig::HashStruct.new 'a' => 'AA', 'b' => %w(a b c), 'c' => nil }

    specify { subject['a'].should == 'AA' }
    specify { subject['a'].should == subject.a }
    specify { subject['c'].should be_nil }

    it 'should raise error, if key is not set', 'this should raise early errors for i.e. typos' do
      expect { subject['d'] }.to raise_error('MethodMissing')
    end

    its(:to_hash) { should == {'a' => 'AA', 'b' => %w(a b c), 'c' => nil} }
  end

  describe 'nested hash struct' do
    let(:config) {{ 'a' => 'AA', 'b' => {'c' => {'e' => 'E', 'f' => 123}, 'd' => %w(a b c d)} }}
    subject { AmberbitConfig::HashStruct.create config }

    specify { subject.b.should be_a(AmberbitConfig::HashStruct) }
    specify { subject.b.c.should be_a(AmberbitConfig::HashStruct) }
    specify { subject.b.c.should == subject['b']['c'] }
    specify { subject.b.c.e.should == 'E' }

    its(:to_hash) { should == config }
  end
end
