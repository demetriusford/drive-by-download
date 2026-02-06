# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe(Dbd::Encoder) do
  describe ".encode" do
    it "encodes file contents to Base64" do
      file = Tempfile.new("test")
      file.write("Hello, World!")
      file.close

      result = described_class.encode(file.path)

      expect(result).to(eq(Base64.strict_encode64("Hello, World!")))
    ensure
      file.unlink
    end

    it "handles binary content correctly" do
      file = Tempfile.new(["test", ".bin"])
      file.binmode
      file.write("\x00\x01\x02\xFF".b)
      file.close

      result = described_class.encode(file.path)

      expect(Base64.strict_decode64(result)).to(eq("\x00\x01\x02\xFF".b))
    ensure
      file.unlink
    end

    it "raises FileNotFoundError for missing files" do
      expect do
        described_class.encode("/nonexistent/file.doc")
      end.to(raise_error(Dbd::Encoder::FileNotFoundError, /File not found/))
    end

    it "raises FileReadError for permission denied" do
      file = Tempfile.new("test")
      file.close
      File.chmod(0o000, file.path)

      expect do
        described_class.encode(file.path)
      end.to(raise_error(Dbd::Encoder::FileReadError, /Permission denied/))
    ensure
      File.chmod(0o644, file.path)
      file.unlink
    end
  end
end
