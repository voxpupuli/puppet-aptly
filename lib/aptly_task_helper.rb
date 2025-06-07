#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/puppet_x/voxpupuli/aptly/cli_helper'
require_relative '../../ruby_task_helper/files/task_helper' unless Object.const_defined?('TaskHelper')

# Aptly task helper
class AptlyTaskHelper < TaskHelper
  NAMESPACE = 'aptly'
  def category
    raise 'Override this method in your class'
  end

  def initialize
    super()
    @category = category
    @supported_methods = self.class.instance_methods(false).filter { |x| x.to_s.start_with? @category }.freeze
    @module_prefix = "#{NAMESPACE}::"
    @accepted_tasks = @supported_methods.map { |x| "#{@module_prefix}#{x}" }.freeze
  end

  def task(opts = {})
    task_name = opts.delete(:_task)
    begin
      case task_name
      when ->(n) { @accepted_tasks.include?(n) }
        method_name = task_name.delete_prefix(@module_prefix)
        result = public_send(method_name, opts)
        { method_name => result }
      else
        raise TaskHelper::Error.new(
          'Task with this name is not found here',
          "#{NAMESPACE}::#{@category}/task-not-found",
          'task_name' => task_name
        )
      end
    rescue PuppetX::Aptly::Error => e
      raise TaskHelper::Error.new(e.message, "#{task_name}/error")
    end
  end
end
