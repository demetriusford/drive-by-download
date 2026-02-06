# frozen_string_literal: true

require "thor"
require_relative "version"
require_relative "validator"
require_relative "payload_service"

module Dbd
  # Thin Thor CLI wrapper for the drive-by-download payload generator.
  #
  # This class is responsible only for:
  # - Parsing command-line options
  # - Delegating to PayloadService
  # - Handling output and errors
  #
  # @example Basic usage (extension inferred from file)
  #   Dbd::CLI.start(["--evil-file=/path/to/document.doc"])
  #
  # @example Override extension
  #   Dbd::CLI.start(["--evil-file=/path/to/file.bin", "--extension=.exe"])
  #
  class CLI < Thor
    # Customizes Thor class methods for CLI behavior.
    class << self
      # Renders help output, excluding the default tree command.
      def help(shell, subcommand = false)
        list = printable_commands(true, subcommand)
        list.reject! { |cmd| cmd[0].include?("tree") }
        Thor::Util.thor_classes_in(self).each do |klass|
          list += klass.printable_commands(false)
        end
        shell.say("Commands:")
        shell.print_table(list, indent: 2, truncate: true)
        shell.say
        class_options_help(shell)
      end

      def exit_on_failure?
        true
      end
    end

    default_task :generate

    desc "generate", "Generate a drive-by-download JavaScript payload"
    method_option :version,
      type: :boolean,
      aliases: "-v",
      desc: "Print version and exit"
    method_option :extension,
      type: :string,
      aliases: "-e",
      desc: "Override extension (#{Validator::VALID_EXTENSIONS.join(", ")})"
    method_option :evil_file,
      type: :string,
      aliases: "-f",
      desc: "Path to the file to embed"

    # Generates the JavaScript payload.
    #
    # @return [void]
    def generate
      return print_version if options[:version]

      validate_required_options!
      payload = execute_service
      $stdout.puts payload
    rescue Validator::InvalidExtensionError,
           Encoder::FileNotFoundError,
           Encoder::FileReadError,
           PayloadGenerator::TemplateNotFoundError,
           PayloadGenerator::TemplateReadError => e
      error_exit(e.message)
    end

    private

    # Prints the version and exits.
    #
    # @return [void]
    def print_version
      $stdout.puts "dbd version #{VERSION}"
    end

    # Validates that required options are provided.
    #
    # @raise [Thor::Error] If required options are missing
    def validate_required_options!
      return if options[:evil_file]

      raise Thor::Error,
        "Missing required option: --evil-file\n" \
          "Run 'dbd help' for usage information."
    end

    # Resolves the extension from options or infers from file path.
    #
    # @return [String] The file extension
    def resolve_extension
      options[:extension] || File.extname(options[:evil_file])
    end

    # Executes the payload service with CLI options.
    #
    # @return [String] The generated payload
    def execute_service
      PayloadService.new(
        extension: resolve_extension,
        file_path: options[:evil_file],
      ).call
    end

    # Prints an error message to stderr and exits.
    #
    # @param message [String] The error message
    def error_exit(message)
      $stderr.puts "Error: #{message}"
      exit(1)
    end
  end
end
