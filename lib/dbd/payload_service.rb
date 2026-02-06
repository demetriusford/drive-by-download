# frozen_string_literal: true

require_relative "validator"
require_relative "filename_generator"
require_relative "encoder"
require_relative "payload_generator"

module Dbd
  # Orchestrates the payload generation workflow.
  #
  # This service coordinates validation, encoding, and payload generation
  # into a single, reusable interface.
  #
  # @example
  #   service = Dbd::PayloadService.new(
  #     extension: ".doc",
  #     file_path: "/path/to/document.doc"
  #   )
  #   javascript_payload = service.call
  #
  class PayloadService
    # @return [String] The file extension for the payload
    attr_reader :extension

    # @return [String] The path to the file to embed
    attr_reader :file_path

    # Initializes a new PayloadService.
    #
    # @param extension [String] The file extension (e.g., ".doc")
    # @param file_path [String] The path to the file to embed
    # @param generator [PayloadGenerator] Optional custom generator
    def initialize(extension:, file_path:, generator: nil)
      @extension = extension
      @file_path = file_path
      @generator = generator || PayloadGenerator.new
    end

    # Generates the JavaScript payload.
    #
    # @return [String] The complete JavaScript payload
    # @raise [Validator::InvalidExtensionError] If extension is invalid
    # @raise [Encoder::FileNotFoundError] If file cannot be found
    # @raise [Encoder::FileReadError] If file cannot be read
    # @raise [PayloadGenerator::TemplateNotFoundError] If template is missing
    # @raise [PayloadGenerator::TemplateReadError] If template cannot be read
    def call
      validate_extension!
      generate_payload
    end

    private

    # Validates extension before processing.
    #
    # @return [void]
    def validate_extension!
      Validator.validate_extension!(@extension)
    end

    # Generates the payload after validation.
    #
    # @return [String] The JavaScript payload
    def generate_payload
      filename = FilenameGenerator.generate(@extension)
      encoded_content = Encoder.encode(@file_path)
      @generator.generate(filename, encoded_content)
    end
  end
end
