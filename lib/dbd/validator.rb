# frozen_string_literal: true

module Dbd
  # Validates input parameters for payload generation.
  #
  # @example
  #   Dbd::Validator.validate_extension!(".doc")
  #
  module Validator
    # Valid file extensions for payload generation
    VALID_EXTENSIONS = [".doc", ".pdf", ".exe"].freeze

    class InvalidExtensionError < StandardError; end

    class << self
      # Validates that the extension is supported.
      #
      # @param extension [String] The extension to validate
      # @return [void]
      # @raise [InvalidExtensionError] If extension is not supported
      def validate_extension!(extension)
        return if VALID_EXTENSIONS.include?(extension)

        raise InvalidExtensionError,
          "Invalid extension '#{extension}'. Valid options: #{VALID_EXTENSIONS.join(", ")}"
      end
    end
  end
end
