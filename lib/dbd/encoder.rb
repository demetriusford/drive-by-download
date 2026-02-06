# frozen_string_literal: true

require "base64"

module Dbd
  # Handles file encoding operations for payload generation.
  #
  # @example
  #   encoded = Dbd::Encoder.encode("/path/to/document.doc")
  #
  module Encoder
    class FileNotFoundError < StandardError; end
    class FileReadError < StandardError; end

    class << self
      # Encodes a file's contents to Base64.
      #
      # @param file_path [String] The path to the file to encode
      # @return [String] Base64-encoded file contents
      # @raise [FileNotFoundError] If the file does not exist
      # @raise [FileReadError] If the file cannot be read
      def encode(file_path)
        content = File.binread(file_path)
        Base64.strict_encode64(content)
      rescue Errno::ENOENT
        raise FileNotFoundError, "File not found: #{file_path}"
      rescue Errno::EACCES
        raise FileReadError, "Permission denied: #{file_path}"
      rescue StandardError => e
        raise FileReadError, "Failed to read file '#{file_path}': #{e.message}"
      end
    end
  end
end
