# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe(Dbd::PayloadService) do
  describe "#call" do
    let(:test_file) do
      file = Tempfile.new(["test", ".doc"])
      file.write("test content")
      file.close
      file
    end

    after do
      test_file.unlink
    end

    it "generates a complete JavaScript payload" do
      service = described_class.new(
        extension: ".doc",
        file_path: test_file.path,
      )

      result = service.call

      expect(result).to(be_a(String))
      expect(result).to(include("((a,b)=>"))
    end

    it "embeds Base64-encoded file content" do
      service = described_class.new(
        extension: ".doc",
        file_path: test_file.path,
      )

      result = service.call
      expected_payload = Base64.strict_encode64("test content")

      expect(result).to(include(expected_payload))
    end

    it "generates filename with correct extension" do
      service = described_class.new(
        extension: ".pdf",
        file_path: test_file.path,
      )

      result = service.call

      expect(result).to(match(/[a-zA-Z0-9]{7}\.pdf/))
    end

    it "validates extension before processing" do
      service = described_class.new(
        extension: ".invalid",
        file_path: test_file.path,
      )

      expect { service.call }.to(raise_error(Dbd::Validator::InvalidExtensionError))
    end

    it "raises error for missing file" do
      service = described_class.new(
        extension: ".doc",
        file_path: "/nonexistent/file.doc",
      )

      expect { service.call }.to(raise_error(Dbd::Encoder::FileNotFoundError))
    end

    it "accepts custom generator" do
      custom_generator = instance_double(Dbd::PayloadGenerator)
      allow(custom_generator).to(receive(:generate).and_return("custom output"))

      service = described_class.new(
        extension: ".doc",
        file_path: test_file.path,
        generator: custom_generator,
      )

      expect(service.call).to(eq("custom output"))
    end
  end

  describe "#extension" do
    it "returns the configured extension" do
      service = described_class.new(extension: ".exe", file_path: "/tmp/test")

      expect(service.extension).to(eq(".exe"))
    end
  end

  describe "#file_path" do
    it "returns the configured file path" do
      service = described_class.new(extension: ".doc", file_path: "/tmp/test.doc")

      expect(service.file_path).to(eq("/tmp/test.doc"))
    end
  end
end
