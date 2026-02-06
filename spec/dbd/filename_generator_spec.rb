# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Dbd::FilenameGenerator) do
  describe ".generate" do
    it "generates filename with correct length" do
      result = described_class.generate(".doc")

      # 7 random chars + extension
      expect(result.sub(/\.doc$/, "").length).to(eq(7))
    end

    it "appends the provided extension" do
      result = described_class.generate(".pdf")

      expect(result).to(end_with(".pdf"))
    end

    it "produces alphanumeric characters" do
      result = described_class.generate(".exe")
      name_part = result.sub(/\.exe$/, "")

      expect(name_part).to(match(/\A[a-zA-Z0-9]+\z/))
    end

    it "produces unique names on each call" do
      results = Array.new(100) { described_class.generate(".doc") }

      expect(results.uniq.length).to(eq(100))
    end

    it "works with different extensions" do
      [".doc", ".pdf", ".exe"].each do |ext|
        result = described_class.generate(ext)
        expect(result).to(end_with(ext))
      end
    end
  end

  describe "::LENGTH" do
    it "is set to 7" do
      expect(described_class::LENGTH).to(eq(7))
    end
  end
end
