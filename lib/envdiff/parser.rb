# frozen_string_literal: true

module Envdiff
  class Parser
    COMMENT_REGEX = /^\s*#/
    EMPTY_LINE_REGEX = /^\s*$/
    ENV_LINE_REGEX = /^([^=]+)=(.*)$/

    def initialize(filepath)
      @filepath = filepath
    end

    def parse
      return {} unless File.exist?(@filepath)

      File.readlines(@filepath).each_with_object({}) do |line, env|
        line = line.strip
        next if line.match?(COMMENT_REGEX) || line.match?(EMPTY_LINE_REGEX)

        if (match = line.match(ENV_LINE_REGEX))
          key = match[1].strip
          value = match[2].strip
          # Remove surrounding quotes if present
          value = value[1..-2] if value.start_with?('"', "'") && value.end_with?('"', "'")
          env[key] = value
        end
      end
    end
  end
end
