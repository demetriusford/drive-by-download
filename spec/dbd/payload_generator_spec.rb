# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe(Dbd::PayloadGenerator) do
  describe "#generate" do
    subject(:generator) { described_class.new }

    it "substitutes filename placeholder" do
      result = generator.generate("test.doc", "cGF5bG9hZA==")

      expect(result).to(include("test.doc"))
      expect(result).not_to(include("<%= filename %>"))
    end

    it "substitutes payload placeholder" do
      result = generator.generate("test.doc", "cGF5bG9hZA==")

      expect(result).to(include("cGF5bG9hZA=="))
      expect(result).not_to(include("<%= payload %>"))
    end

    it "produces valid JavaScript structure" do
      result = generator.generate("test.doc", "cGF5bG9hZA==")

      expect(result).to(start_with("((a,b)=>{"))
      expect(result).to(include("test.doc"))
      expect(result).to(include("cGF5bG9hZA=="))
    end

    it "includes obfuscated function calls" do
      result = generator.generate("test.doc", "cGF5bG9hZA==")

      expect(result).to(include("'at'+'ob'"))
      expect(result).to(include("'Bl'+'ob'"))
    end
  end

  describe "#initialize" do
    it "uses default template path when none provided" do
      generator = described_class.new

      expect { generator.generate("test.doc", "cGF5bG9hZA==") }.not_to(raise_error)
    end

    it "accepts custom template path" do
      template = Tempfile.new(["custom", ".erb"])
      template.write("custom:<%= filename %>:<%= payload %>")
      template.close

      generator = described_class.new(template.path)
      result = generator.generate("test.doc", "cGF5bG9hZA==")

      expect(result).to(eq("custom:test.doc:cGF5bG9hZA=="))
    ensure
      template.unlink
    end
  end

  describe "error handling" do
    it "raises TemplateNotFoundError for missing template" do
      generator = described_class.new("/nonexistent/template.erb")

      expect do
        generator.generate("test.doc", "cGF5bG9hZA==")
      end.to(raise_error(Dbd::PayloadGenerator::TemplateNotFoundError, /Template not found/))
    end
  end
end
