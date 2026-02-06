# frozen_string_literal: true

require_relative "dbd/version"
require_relative "dbd/validator"
require_relative "dbd/filename_generator"
require_relative "dbd/encoder"
require_relative "dbd/payload_generator"
require_relative "dbd/payload_service"

# Drive-by-download payload generator.
#
# A toolkit for generating JavaScript payloads that trigger
# automatic file downloads in web browsers.
#
# @example Using the service directly
#   payload = Dbd::PayloadService.new(
#     extension: ".doc",
#     file_path: "/path/to/document.doc"
#   ).call
#
# @example Using individual components
#   encoded = Dbd::Encoder.encode("/path/to/document.doc")
#   filename = Dbd::FilenameGenerator.generate(".doc")
#   payload = Dbd::PayloadGenerator.new.generate(filename, encoded)
#
module Dbd
end
