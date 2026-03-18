# frozen_string_literal: true

require "envdiff"
require "tempfile"

RSpec.describe Envdiff do
  describe Envdiff::Parser do
    it "parses simple key=value pairs" do
      file = Tempfile.new(".env")
      file.write("FOO=bar\nBAZ=qux")
      file.close

      result = Envdiff::Parser.new(file.path).parse
      expect(result).to eq({ "FOO" => "bar", "BAZ" => "qux" })
    ensure
      file.unlink
    end

    it "ignores comments and empty lines" do
      file = Tempfile.new(".env")
      file.write("# comment\nFOO=bar\n\n  # another comment\nBAZ=qux")
      file.close

      result = Envdiff::Parser.new(file.path).parse
      expect(result).to eq({ "FOO" => "bar", "BAZ" => "qux" })
    ensure
      file.unlink
    end

    it "handles quoted values" do
      file = Tempfile.new(".env")
      file.write("FOO=\"bar baz\"\nQUX='hello world'")
      file.close

      result = Envdiff::Parser.new(file.path).parse
      expect(result).to eq({ "FOO" => "bar baz", "QUX" => "hello world" })
    ensure
      file.unlink
    end

    it "returns empty hash for non-existent file" do
      result = Envdiff::Parser.new("/nonexistent/.env").parse
      expect(result).to eq({})
    end
  end

  describe Envdiff::Comparator do
    it "finds keys only in left" do
      left = { "FOO" => "bar", "ONLY_LEFT" => "value" }
      right = { "FOO" => "bar" }

      result = Envdiff::Comparator.new(left, right).compare
      expect(result.only_in_left).to eq(["ONLY_LEFT"])
    end

    it "finds keys only in right" do
      left = { "FOO" => "bar" }
      right = { "FOO" => "bar", "ONLY_RIGHT" => "value" }

      result = Envdiff::Comparator.new(left, right).compare
      expect(result.only_in_right).to eq(["ONLY_RIGHT"])
    end

    it "finds different values" do
      left = { "FOO" => "bar" }
      right = { "FOO" => "baz" }

      result = Envdiff::Comparator.new(left, right).compare
      expect(result.different_values.keys).to eq(["FOO"])
      expect(result.different_values["FOO"].left).to eq("bar")
      expect(result.different_values["FOO"].right).to eq("baz")
    end

    it "identifies matching keys" do
      left = { "FOO" => "bar", "BAZ" => "qux" }
      right = { "FOO" => "bar", "BAZ" => "qux" }

      result = Envdiff::Comparator.new(left, right).compare
      expect(result.same).to contain_exactly("BAZ", "FOO")
    end
  end
end
