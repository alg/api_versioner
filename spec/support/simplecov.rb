# frozen_string_literal: true

if ENV['SIMPLECOV'] == 'true'
  puts 'RSpec started with SIMPLECOV'

  require 'simplecov'
  SimpleCov.start('rails') do
    enable_coverage :branch

    add_filter 'spec/rails_helper.rb'
    add_filter 'lib/tasks'

    # Abstract classes
    add_filter 'app/channels/application_cable/channel.rb'
    add_filter 'app/channels/application_cable/connection.rb'
    add_filter 'app/controllers/application_controller.rb'
    add_filter 'app/jobs/application_job.rb'
    add_filter 'app/mailers/application_mailer.rb'
    add_filter 'app/models/application_record.rb'

    Dir.glob('app/graphql/**/base_*').each { |file_to_exclude| add_filter file_to_exclude }
  end

  # Disable default html formatter for CircleCI
  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter if ENV['CI']
  SimpleCov.minimum_coverage line: 100, branch: 100
  SimpleCov.at_exit { CustomSimpleCov::Result.new(SimpleCov.result).print_result }

  class SimpleCov::SourceFile
    def uncovered?
      covered_percent < 100 || branches_coverage_percent < 100
    end
  end

  module CustomSimpleCov
    class MissedBranch
      def initialize(file, branch)
        @type = branch.type
        @line_number = branch.report_line
        @src = file.lines[@line_number - 1].src.strip
      end

      def to_s
        "#{@line_number}\t#{@src} # (uncovered branch :#{@type})"
      end
    end

    class MissedLine
      def initialize(line)
        @line_number = line.line_number
        @src = line.src
      end

      def to_s
        "#{@line_number}\t#{@src}"
      end
    end

    class Result
      def initialize(result)
        @result = result
      end

      def print_result
        statistics = result.coverage_statistics
        percent = ((statistics[:line].percent + statistics[:branch].percent) / 2.0).ceil(2)

        uncovered_files.each { |file| print_uncovered_file(file) } if percent < 100
        puts "(#{percent}%) covered"
      end

      private

      attr_reader :result

      def print_uncovered_file(file)
        puts "Uncovered file: #{file.filename}:"

        print_missed_lines(file)
        print_missed_branches(file)

        puts
      end

      def print_missed_lines(file)
        file.missed_lines.each { |line| puts MissedLine.new(line) }
      end

      def print_missed_branches(file)
        file.missed_branches.each { |branch| puts MissedBranch.new(file, branch) }
      end

      def uncovered_files
        result.files.select(&:uncovered?)
      end
    end
  end
end
