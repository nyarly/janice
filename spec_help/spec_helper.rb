require 'rspec'
require 'rspec/core/formatters/base_formatter'
require 'file-sandbox'
require 'cadre/rspec3'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.add_formatter(Cadre::RSpec3::NotifyOnCompleteFormatter)
  config.add_formatter(Cadre::RSpec3::QuickfixFormatter)

  config.backtrace_exclusion_patterns =[/(?-mix:(?-mix:\/lib\/rspec\/(core|mocks|expectations|support|matchers|rails|autorun)(\.rb|\/))|rubygems\/core_ext\/kernel_require\.rb)|(?-mix:\/libd*\/ruby\/)|(?-mix:org\/jruby\/)|(?-mix:bin\/)/]
end
