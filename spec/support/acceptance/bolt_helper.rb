# frozen_string_literal: true

require 'json'

# Run bolt task and return parsed JSON
def bolt_task_run(name, options = {})
  optkv = options.map { |k, v| "'#{k}=#{v}'" }
  targets = options.delete(:targets) || 'localhost'
  result = shell("bolt task run -t '#{targets}' --format=json --verbose '#{name}' #{optkv.join(' ')}")
  JSON.parse(result.stdout.chomp)['items'][0]['value']
end

# Run bolt plan and return parsed JSON
def bolt_plan_run(name, options = {})
  optkv = options.map { |k, v| "'#{k}=#{v}'" }
  result = shell("bolt plan run --format=json --verbose '#{name}' #{optkv.join(' ')}")
  JSON.parse(result.stdout.chomp)
end
