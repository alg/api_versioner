# frozen_string_literal: true

if RUBY_ENGINE == 'ruby' && (ARGV.none? || ARGV == ['spec'] || ARGV == ['spec/'])
  require 'simplecov'

  SimpleCov.start do
    enable_coverage :branch
    minimum_coverage line: 100, branch: 100
  end
end
