# frozen_string_literal: true

require "spec_helper"
require "open3"
require "tempfile"

RSpec.describe("CLI Integration") do
  let(:bin_path) { File.expand_path("../../bin/dbd", __dir__) }

  let(:test_file) do
    file = Tempfile.new(["test", ".doc"])
    file.write("test content")
    file.close
    file
  end

  after do
    test_file.unlink
  end

  describe "payload generation" do
    it "outputs valid JavaScript" do
      stdout, status = Open3.capture2(bin_path, "-f", test_file.path)

      expect(status.success?).to(be(true))
      expect(stdout).to(start_with("((a,b)=>{"))
    end

    it "infers extension from input file" do
      stdout, _status = Open3.capture2(bin_path, "-f", test_file.path)

      expect(stdout).to(match(/[a-zA-Z0-9]{7}\.doc/))
    end

    it "allows extension override" do
      stdout, _status = Open3.capture2(bin_path, "-f", test_file.path, "-e", ".exe")

      expect(stdout).to(match(/[a-zA-Z0-9]{7}\.exe/))
    end

    it "embeds file content as Base64" do
      stdout, _status = Open3.capture2(bin_path, "-f", test_file.path)
      expected_payload = Base64.strict_encode64("test content")

      expect(stdout).to(include(expected_payload))
    end

    it "substitutes filename placeholder" do
      stdout, _status = Open3.capture2(bin_path, "-f", test_file.path)

      expect(stdout).not_to(include("<%= filename %>"))
    end

    it "substitutes payload placeholder" do
      stdout, _status = Open3.capture2(bin_path, "-f", test_file.path)

      expect(stdout).not_to(include("<%= payload %>"))
    end
  end

  describe "error handling" do
    it "exits 1 for missing file" do
      _stdout, stderr, status = Open3.capture3(bin_path, "-f", "/nonexistent/file.doc")

      expect(status.exitstatus).to(eq(1))
      expect(stderr).to(include("File not found"))
    end

    it "exits 1 for invalid extension" do
      _stdout, stderr, status = Open3.capture3(bin_path, "-f", test_file.path, "-e", ".xyz")

      expect(status.exitstatus).to(eq(1))
      expect(stderr).to(include("Invalid extension"))
    end

    it "exits 1 when no file provided" do
      _stdout, stderr, status = Open3.capture3(bin_path)

      expect(status.exitstatus).to(eq(1))
      expect(stderr).to(include("Missing required option"))
    end
  end

  describe "version flag" do
    it "prints version and exits successfully" do
      stdout, status = Open3.capture2(bin_path, "--version")

      expect(status.success?).to(be(true))
      expect(stdout).to(match(/dbd version \d+\.\d+\.\d+/))
    end

    it "supports short flag" do
      stdout, status = Open3.capture2(bin_path, "-v")

      expect(status.success?).to(be(true))
      expect(stdout).to(include("dbd version"))
    end
  end

  describe "help flag" do
    it "prints help information" do
      stdout, status = Open3.capture2(bin_path, "help")

      expect(status.success?).to(be(true))
      expect(stdout).to(include("Commands:"))
    end
  end
end
