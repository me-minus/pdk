require 'spec_helper_acceptance'

describe 'pdk new transport', module_command: true do
  def update_module!
    command('pdk update --force').exit_status
  end

  context 'when run inside of a module' do
    include_context 'in a new module', 'new_transport'

    describe command('pdk new transport test_transport') do
      its(:stdout) { is_expected.to match(/#{File.join('lib', 'puppet', 'transport')}/) }
      its(:stdout) { is_expected.to match(/#{File.join('lib', 'puppet', 'transport', 'schema', 'test_transport.rb')}/) }
      its(:stdout) { is_expected.to match(/#{File.join('lib', 'puppet', 'util', 'network_device', 'test_transport', 'device.rb')}/) }
      its(:stdout) { is_expected.to match(/#{File.join('spec', 'unit', 'puppet', 'transport', 'test_transport_spec.rb')}/) }
      its(:stdout) { is_expected.to match(/#{File.join('spec', 'unit', 'puppet', 'transport', 'schema', 'test_transport_spec.rb')}/) }
      its(:stderr) { is_expected.to have_no_output }
      its(:exit_status) { is_expected.to eq(0) }

      describe file(File.join('lib', 'puppet', 'transport')) do
        it { is_expected.to be_directory }
      end

      describe file(File.join('lib', 'puppet', 'transport', 'test_transport.rb')) do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(/class TestTransport/) }
      end

      describe file(File.join('lib', 'puppet', 'transport', 'schema')) do
        it { is_expected.to be_directory }
      end

      describe file(File.join('lib', 'puppet', 'transport', 'schema', 'test_transport.rb')) do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(/Puppet::ResourceApi.register_transport/) }
        its(:content) { is_expected.to match(/name: 'test_transport'/) }
      end

      describe file(File.join('lib', 'puppet', 'util', 'network_device', 'test_transport')) do
        it { is_expected.to be_directory }
      end

      describe file(File.join('lib', 'puppet', 'util', 'network_device', 'test_transport', 'device.rb')) do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(/Puppet::Util::NetworkDevice::Test_transport/) } # puppet defaults to `capitalize`ing instead of snake case like ruby would prefer
        its(:content) { is_expected.to match(/super\('test_transport', url_or_config\)/) }
      end

      describe file(File.join('spec', 'unit', 'puppet', 'transport')) do
        it { is_expected.to be_directory }
      end

      describe file(File.join('spec', 'unit', 'puppet', 'transport', 'test_transport_spec.rb')) do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(/RSpec.describe Puppet::Transport::TestTransport do/) }
      end

      describe file(File.join('spec', 'unit', 'puppet', 'transport', 'schema')) do
        it { is_expected.to be_directory }
      end

      describe file(File.join('spec', 'unit', 'puppet', 'transport', 'schema', 'test_transport_spec.rb')) do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(/RSpec.describe 'the test_transport transport' do/) }
      end

      describe command('pdk validate ruby') do
        its(:stdout) { is_expected.to have_no_output }
        its(:stderr) { is_expected.to match(/using ruby \d+\.\d+\.\d+/i) }
        its(:stderr) { is_expected.to match(/using puppet \d+\.\d+\.\d+/i) }
        its(:exit_status) { is_expected.to eq(0) }
      end

      describe command('pdk test unit') do
        its(:stdout) { is_expected.to match(/0 failures/) }
        its(:stdout) { is_expected.not_to match(/no examples found/i) }
        its(:exit_status) { is_expected.to eq(0) }
      end
    end
  end
end
