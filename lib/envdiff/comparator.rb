# frozen_string_literal: true

module Envdiff
  class Comparator
    Result = Struct.new(:only_in_left, :only_in_right, :different_values, :same, keyword_init: true)
    ValueDiff = Struct.new(:left, :right, keyword_init: true)

    def initialize(left, right)
      @left = left
      @right = right
    end

    def compare
      all_keys = (@left.keys | @right.keys).sort

      only_in_left = []
      only_in_right = []
      different_values = {}
      same = []

      all_keys.each do |key|
        left_val = @left[key]
        right_val = @right[key]

        if left_val.nil?
          only_in_right << key
        elsif right_val.nil?
          only_in_left << key
        elsif left_val != right_val
          different_values[key] = ValueDiff.new(left: left_val, right: right_val)
        else
          same << key
        end
      end

      Result.new(
        only_in_left: only_in_left,
        only_in_right: only_in_right,
        different_values: different_values,
        same: same
      )
    end
  end
end
