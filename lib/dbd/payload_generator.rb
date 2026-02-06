# frozen_string_literal: true

require "erb"

module Dbd
  # Generates JavaScript payloads using ERB template substitution.
  #
  # @example
  #   generator = Dbd::PayloadGenerator.new
  #   payload = generator.generate("document.doc", "SGVsbG8gV29ybGQ=")
  #
  class PayloadGenerator
    class TemplateNotFoundError < StandardError; end
    class TemplateReadError < StandardError; end

    # Initializes the generator with the template path.
    #
    # @param template_path [String, nil] Custom template path (optional)
    def initialize(template_path = nil)
      @template_path = template_path || default_template_path
    end

    # Generates a JavaScript payload with the given filename and base64 data.
    #
    # @param filename [String] The filename to embed in the payload
    # @param base64_payload [String] The Base64-encoded file content
    # @return [String] The complete JavaScript payload
    # @raise [TemplateNotFoundError] If the template file does not exist
    # @raise [TemplateReadError] If the template cannot be read
    def generate(filename, base64_payload)
      template = ERB.new(read_template)
      template.result_with_hash(filename: filename, payload: base64_payload)
    end

    private

    # Returns the default template path relative to the gem root.
    #
    # @return [String] Path to the default template
    def default_template_path
      File.expand_path("../../../templates/payload.js.erb", __FILE__)
    end

    # Reads the template file contents.
    #
    # @return [String] Template contents
    # @raise [TemplateNotFoundError] If template does not exist
    # @raise [TemplateReadError] If template cannot be read
    def read_template
      File.read(@template_path)
    rescue Errno::ENOENT
      raise TemplateNotFoundError, "Template not found: #{@template_path}"
    rescue StandardError => e
      raise TemplateReadError, "Failed to read template '#{@template_path}': #{e.message}"
    end
  end
end
