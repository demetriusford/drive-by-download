# frozen_string_literal: true

require "securerandom"

module Dbd
  # Generates random filenames for payload delivery.
  #
  # @example
  #   Dbd::FilenameGenerator.generate(".doc") #=> "xK9mPqw.doc"
  #
  module FilenameGenerator
    # Length of the random portion of generated filenames
    LENGTH = 7

    class << self
      # Generates a random alphanumeric filename with the given extension.
      #
      # @param extension [String] The file extension (e.g., '.doc')
      # @return [String] A random filename with the extension
      def generate(extension)
        random_name = SecureRandom.alphanumeric(LENGTH)
        "#{random_name}#{extension}"
      end
    end
  end
end
