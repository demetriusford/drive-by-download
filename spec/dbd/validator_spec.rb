# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Dbd::Validator) do
  describe ".validate_extension!" do
    it "accepts .doc extension" do
      expect { described_class.validate_extension!(".doc") }.not_to(raise_error)
    end

    it "accepts .pdf extension" do
      expect { described_class.validate_extension!(".pdf") }.not_to(raise_error)
    end

    it "accepts .exe extension" do
      expect { described_class.validate_extension!(".exe") }.not_to(raise_error)
    end

    it "rejects invalid extensions" do
      expect do
        described_class.validate_extension!(".txt")
      end.to(raise_error(Dbd::Validator::InvalidExtensionError, /Invalid extension/))
    end

    it "rejects extensions without leading dot" do
      expect do
        described_class.validate_extension!("doc")
      end.to(raise_error(Dbd::Validator::InvalidExtensionError))
    end

    it "is case sensitive" do
      expect do
        described_class.validate_extension!(".DOC")
      end.to(raise_error(Dbd::Validator::InvalidExtensionError))
    end

    it "includes valid options in error message" do
      expect do
        described_class.validate_extension!(".xyz")
      end.to(raise_error(Dbd::Validator::InvalidExtensionError, /\.doc.*\.pdf.*\.exe/))
    end
  end

  describe "::VALID_EXTENSIONS" do
    it "is frozen" do
      expect(described_class::VALID_EXTENSIONS).to(be_frozen)
    end

    it "contains expected extensions" do
      expect(described_class::VALID_EXTENSIONS).to(contain_exactly(".doc", ".pdf", ".exe"))
    end
  end
end
