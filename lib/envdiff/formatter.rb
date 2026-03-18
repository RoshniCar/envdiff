# frozen_string_literal: true

module Envdiff
  class Formatter
    COLORS = {
      red: "\e[31m",
      green: "\e[32m",
      yellow: "\e[33m",
      cyan: "\e[36m",
      dim: "\e[2m",
      reset: "\e[0m"
    }.freeze

    def initialize(result, left_name:, right_name:, color: true)
      @result = result
      @left_name = left_name
      @right_name = right_name
      @color = color
    end

    def format
      output = []

      if @result.only_in_left.any?
        output << header("Only in #{@left_name}", :red)
        @result.only_in_left.each { |key| output << "  - #{key}" }
        output << ""
      end

      if @result.only_in_right.any?
        output << header("Only in #{@right_name}", :green)
        @result.only_in_right.each { |key| output << "  + #{key}" }
        output << ""
      end

      if @result.different_values.any?
        output << header("Different values", :yellow)
        @result.different_values.each do |key, diff|
          output << "  #{key}:"
          output << "    #{colorize(@left_name, :dim)}: #{mask_value(diff.left)}"
          output << "    #{colorize(@right_name, :dim)}: #{mask_value(diff.right)}"
        end
        output << ""
      end

      if output.empty?
        output << colorize("✓ Files are identical", :green)
      else
        summary = "#{@result.same.length} matching, "
        summary += "#{@result.only_in_left.length} only in #{@left_name}, "
        summary += "#{@result.only_in_right.length} only in #{@right_name}, "
        summary += "#{@result.different_values.length} different"
        output << colorize(summary, :dim)
      end

      output.join("\n")
    end

    private

    def header(text, color)
      colorize("#{text}:", color)
    end

    def colorize(text, color)
      return text unless @color

      "#{COLORS[color]}#{text}#{COLORS[:reset]}"
    end

    def mask_value(value)
      return value if value.length <= 4

      # Mask sensitive-looking values (tokens, keys, etc.)
      if value.length > 20 || value.match?(/^(sk-|pk-|ghp_|gho_)/)
        "#{value[0..3]}#{"*" * [value.length - 4, 8].min}"
      else
        value
      end
    end
  end
end
