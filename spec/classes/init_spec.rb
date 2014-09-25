require 'spec_helper'
describe 'security' do

  context 'with defaults for all parameters' do
    it { should contain_class('security') }
  end
end
