# frozen_string_literal: true

require 'bolt_spec/plans'

RSpec.shared_context 'boltspec' do
  include BoltSpec::Plans
  before :all do # rubocop:disable RSpec/BeforeAfterAll
    BoltSpec::Plans.init
    execute_no_plan
  end

  # BoltSpec wants the module path to be an array
  def modulepath
    RSpec.configuration.module_path.split(':')
  end
end

RSpec.configure do |c|
  # To remove on RSpec >= 4
  # https://rspec.info/features/3-12/rspec-core/example-groups/shared-context/
  c.shared_context_metadata_behavior = :apply_to_host_groups

  # Run Bolt plan tests with BoltSpec enabled
  c.include_context 'boltspec', file_path: proc { |x| ['plans'].include? File.dirname(x).split('/')[-1] }
end
