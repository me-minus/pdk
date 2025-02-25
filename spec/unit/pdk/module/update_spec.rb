require 'spec_helper'
require 'pdk/module/update'

describe PDK::Module::Update do
  let(:module_root) { File.join('path', 'to', 'update') }
  let(:options) { {} }
  let(:mock_metadata) do
    instance_double(
      PDK::Module::Metadata,
      data: {
        'name' => 'mock-module',
        'template-url' => template_url,
        'template-ref' => template_ref
      }
    )
  end
  let(:template_url) { 'https://github.com/puppetlabs/pdk-templates' }
  let(:template_ref) { nil }

  def module_path(relative_path)
    File.join(module_root, relative_path)
  end

  shared_context 'with mock metadata' do
    before do
      allow(PDK::Module::Metadata).to receive(:from_file).with(module_path('metadata.json')).and_return(mock_metadata)
    end
  end

  describe '#pinned_to_puppetlabs_template_tag?' do
    subject { instance.pinned_to_puppetlabs_template_tag? }

    let(:instance) { described_class.new(module_root, options) }

    include_context 'with mock metadata'

    context 'when running from a package install' do
      include_context 'packaged install'

      before do
        allow(PDK::Util).to receive(:development_mode?).and_return(false)
      end

      context 'and the template-url is set to the pdk-default keyword' do
        let(:template_url) { 'pdk-default#1.0.0' }

        before do
          allow(PDK::Util::Git).to receive(:tag?).with(any_args).and_return(true)
        end

        it { is_expected.to be_falsey }
      end

      context 'and the template-url is not set to the pdk-default keyword' do
        let(:template_url) { 'https://github.com/puppetlabs/pdk-templates' }

        context 'and the url fragment is set to a tag name' do
          let(:template_url) { "#{super()}#1.0.0" }

          before do
            allow(PDK::Util::Git).to receive(:tag?).with(*template_url.split('#')).and_return(true)
          end

          it { is_expected.to be_truthy }
        end

        context 'and the url fragment is set to the latest template tag' do
          let(:template_url) { super() + "##{PDK::TEMPLATE_REF}" }

          before do
            allow(PDK::Util::Git).to receive(:tag?).with(*template_url.split('#')).and_return(true)
          end

          it { is_expected.to be_falsey }
        end

        context 'and the url fragment is not set to a tag name' do
          let(:template_url) { "#{super()}#my_branch" }

          before do
            allow(PDK::Util::Git).to receive(:tag?).with(*template_url.split('#')).and_return(false)
          end

          it { is_expected.to be_falsey }
        end
      end
    end

    context 'when not running from a package install' do
      include_context 'not packaged install'

      context 'and the template-url is set to the pdk-default keyword' do
        let(:template_url) { 'pdk-default#1.0.0' }

        before do
          allow(PDK::Util::Git).to receive(:tag?).with(any_args).and_return(true)
        end

        it { is_expected.to be_truthy }
      end

      context 'and the template-url is not set to the pdk-default keyword' do
        let(:template_url) { 'https://github.com/puppetlabs/pdk-templates' }

        context 'and the url fragment is set to a tag name' do
          let(:template_url) { "#{super()}#1.0.0" }

          before do
            allow(PDK::Util::Git).to receive(:tag?).with(*template_url.split('#')).and_return(true)
          end

          it { is_expected.to be_truthy }
        end

        context 'and the url fragment is set to the latest template tag' do
          let(:template_url) { super() + "##{PDK::TEMPLATE_REF}" }

          before do
            allow(PDK::Util::Git).to receive(:tag?).with(*template_url.split('#')).and_return(true)
          end

          it { is_expected.to be_falsey }
        end

        context 'and the url fragment is not set to a tag name' do
          let(:template_url) { "#{super()}#my_branch" }

          before do
            allow(PDK::Util::Git).to receive(:tag?).with(*template_url.split('#')).and_return(false)
          end

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe '#run' do
    let(:instance) { described_class.new(module_root, options) }
    let(:template_ref) { '1.3.2-0-g1234567' }
    let(:changes) { true }

    include_context 'with mock metadata'

    before do
      allow(instance).to receive(:stage_changes!)
      allow(instance).to receive(:print_summary)
      allow(instance).to receive(:new_version).and_return('1.4.0')
      allow(instance).to receive(:print_result)
      allow(PDK::Util::Git).to receive(:tag?).with(String, String).and_return(true)
      allow(instance.update_manager).to receive(:sync_changes!)
      allow(instance.update_manager).to receive(:changes?).and_return(changes)
      allow(instance.update_manager).to receive(:unlink_file).with('Gemfile.lock')
      allow(instance.update_manager).to receive(:unlink_file).with(File.join('.bundle', 'config'))
      allow(PDK::Util::Bundler).to receive(:ensure_bundle!)
    end

    after do
      instance.run
    end

    context 'when the version is the same' do
      let(:options) { { noop: true } }

      before do
        allow(instance).to receive(:current_version).and_return('1.4.0')
      end

      context 'but there are changes' do
        let(:changes) { true }

        it 'does add debug message' do
          expect(logger).to receive(:debug).with(a_string_matching(/This module is already up to date with version 1.4.0 of the template/i))
        end

        it 'doesn\'t add report with no changes' do
          expect(PDK::Report.default_target).not_to receive(:puts).with(a_string_matching(/No changes required./i))
        end
      end

      context 'but there are no changes' do
        let(:changes) { false }

        it 'does add debug message' do
          expect(logger).to receive(:debug).with(a_string_matching(/This module is already up to date with version 1.4.0 of the template/))
        end

        it 'does add report with no changes' do
          expect(PDK::Report.default_target).to receive(:puts).with(a_string_matching(/No changes required./i))
        end
      end
    end

    context 'when using the default template' do
      let(:options) { { noop: true } }
      let(:template_url) { PDK::Util::TemplateURI.default_template_uri.metadata_format }

      it 'refers to the template as the default template' do
        expect(logger).to receive(:info).with(a_string_matching(/using the default template/i))
      end
    end

    context 'when using a custom template' do
      let(:options) { { noop: true } }
      let(:template_url) { 'https://my/custom/template' }

      it 'refers to the template by its URL or path' do
        expect(logger).to receive(:info).with(a_string_matching(/using the template at #{Regexp.escape(template_url)}/i))
      end
    end

    context 'when running in noop mode' do
      let(:options) { { noop: true } }

      it 'does not prompt the user to make the changes' do
        expect(PDK::CLI::Util).not_to receive(:prompt_for_yes)
      end

      it 'does not sync the pending changes' do
        expect(instance.update_manager).not_to receive(:sync_changes!)
      end
    end

    context 'when not running in noop mode' do
      context 'with force' do
        let(:options) { { force: true } }

        it 'does not prompt the user to make the changes' do
          expect(PDK::CLI::Util).not_to receive(:prompt_for_yes)
        end

        it 'syncs the pending changes' do
          expect(instance.update_manager).to receive(:sync_changes!)
        end
      end

      context 'without force' do
        it 'prompts the user to make the changes' do
          expect(PDK::CLI::Util).to receive(:prompt_for_yes)
        end

        context 'if the user chooses to continue' do
          before do
            allow(PDK::CLI::Util).to receive(:prompt_for_yes).and_return(true)
          end

          it 'syncs the pending changes' do
            expect(instance.update_manager).to receive(:sync_changes!)
          end

          it 'prints the result' do
            expect(instance).to receive(:print_result)
          end
        end

        context 'if the user chooses not to continue' do
          before do
            allow(PDK::CLI::Util).to receive(:prompt_for_yes).and_return(false)
          end

          it 'does not sync the pending changes' do
            expect(instance.update_manager).not_to receive(:sync_changes!)
          end

          it 'does not print the result' do
            expect(instance).not_to receive(:print_result)
          end
        end
      end
    end
  end

  describe '#module_metadata' do
    subject(:result) { described_class.new(module_root, options).module_metadata }

    context 'when the metadata.json can be read' do
      include_context 'with mock metadata'

      it 'returns the metadata object' do
        expect(subject).to eq(mock_metadata)
      end
    end

    context 'when the metadata.json can not be read' do
      before do
        allow(PDK::Module::Metadata).to receive(:from_file).with(module_path('metadata.json')).and_raise(ArgumentError, 'some error')
      end

      it 'raises an ExitWithError exception' do
        expect { -> { result }.call }.to raise_error(PDK::CLI::ExitWithError, /some error/i)
      end
    end
  end

  describe '#template_uri' do
    subject { described_class.new(module_root, options).template_uri.to_s }

    include_context 'with mock metadata'

    it 'returns the template-url value from the module metadata' do
      expect(subject).to eq('https://github.com/puppetlabs/pdk-templates')
    end
  end

  describe '#current_version' do
    subject { described_class.new(module_root, options).current_version }

    include_context 'with mock metadata'

    context 'when the template-ref describes a git tag' do
      let(:template_ref) { '1.3.2-0-g07678c8' }

      it 'returns the tag name' do
        expect(subject).to eq('1.3.2')
      end
    end

    context 'when the template-ref describes a branch commit' do
      let(:template_ref) { 'heads/main-4-g1234abc' }

      it 'returns the branch name and the commit SHA' do
        expect(subject).to eq('main@1234abc')
      end
    end
  end

  describe '#new_version' do
    subject { described_class.new(module_root, options).new_version }

    include_context 'with mock metadata'

    context 'when the default_template_ref specifies a tag' do
      before do
        allow(PDK::Util).to receive(:development_mode?).and_return(false)
      end

      it 'returns the tag name' do
        expect(subject).to eq(PDK::TEMPLATE_REF)
      end
    end

    context 'when the default_template_ref specifies a branch head' do
      before do
        stub_const('PDK::TEMPLATE_REF', '2.7.1')
        allow(PDK::Util::Git).to receive(:ls_remote)
          .with(template_url, 'main')
          .and_return('3cdd84e8f0aae30bf40d15556482fc8752899312')
      end

      include_context 'with mock metadata'
      let(:template_ref) { 'main-0-g07678c8' }

      it 'returns the branch name and the commit SHA' do
        expect(subject).to eq('main@3cdd84e')
      end
    end
  end

  describe '#new_template_version' do
    subject { described_class.new(module_root, options).new_template_version }

    include_context 'with mock metadata'

    let(:module_template_ref) { '0.0.1' }
    let(:module_template_uri) do
      instance_double(
        PDK::Util::TemplateURI,
        default?: true,
        bare_uri: 'https://github.com/puppetlabs/pdk-templates',
        uri_fragment: module_template_ref
      )
    end
    let(:template_url) { "https://github.com/puppetlabs/pdk-templates##{module_template_ref}" }

    before do
      allow(PDK::Util::TemplateURI).to receive(:new).and_call_original
      allow(PDK::Util::TemplateURI).to receive(:new).with(template_url).and_return(module_template_uri)
    end

    context 'when a template-ref is specified' do
      let(:options) { { 'template-ref': 'my-custom-branch' } }

      it 'returns the specified template-ref value' do
        expect(subject).to eq('my-custom-branch')
      end
    end

    context 'when template-ref is not specified' do
      context 'and the module is using the default template' do
        before do
          allow(module_template_uri).to receive(:default?).and_return(true)
        end

        context 'and the ref of the template is a tag' do
          before do
            allow(PDK::Util::Git).to receive(:tag?).with(String, module_template_ref).and_return(true)
          end

          context 'and PDK is running from a package install' do
            before do
              allow(PDK::Util).to receive(:package_install?).and_return(true)
              allow(PDK::Util::Version).to receive(:git_ref).and_return('1234acb')
              allow(PDK::Util).to receive(:package_cachedir).and_return(File.join('package', 'cachedir'))
            end

            it 'returns the default ref' do
              expect(subject).to eq(PDK::Util::TemplateURI.default_template_ref)
            end
          end

          context 'and PDK is not running from a package install' do
            before do
              allow(PDK::Util).to receive(:package_install?).and_return(false)
            end

            it 'returns the ref from the metadata' do
              expect(subject).to eq(template_url.split('#').last)
            end
          end
        end

        context 'but the ref of the template is not a tag' do
          before do
            allow(PDK::Util::Git).to receive(:tag?).with(String, module_template_ref).and_return(false)
          end

          it 'returns the ref from the metadata' do
            expect(subject).to eq(template_url.split('#').last)
          end
        end
      end

      context 'but the module is not using the default template' do
        before do
          allow(module_template_uri).to receive(:default?).and_return(false)
        end

        it 'returns the ref stored in the template_url metadata' do
          expect(subject).to eq(template_url.split('#').last)
        end
      end
    end
  end

  describe '#convert?' do
    subject { described_class.new(module_root).convert? }

    it { is_expected.to be_falsey }
  end
end
