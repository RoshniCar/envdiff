# frozen_string_literal: true

require_relative "envdiff/version"
require_relative "envdiff/parser"
require_relative "envdiff/comparator"
require_relative "envdiff/formatter"

module Envdiff
  class Error < StandardError; end
end
