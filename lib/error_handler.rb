# frozen_string_literal: true

require_relative './modules/file_reader'
# rubocop:disable Style/Documentation
class ErrorHandler
  include FileReader

  attr_reader :errors, :error_message

  def initialize
    @errors = []
    @error_messages = {
      indentation: {
        err_message: 'Identation errors',
        type: 'error',
        color: :red,
        line: 0
      },
      traillig_spaces: {
        err_message: 'Trailling unecessary white space error',
        type: 'error',
        color: :red,
        line: 0
      },
      tag: {
        err_message: 'Missing or unexpected tag',
        type: 'error',
        color: :red,
        line: 0
      },
      bloc: {
        err_message: 'Bloc not closed error',
        type: 'error',
        color: :red,
        line: 0
      },
      empty_line: {
        err_message: 'Empty space error in your code',
        type: 'warning',
        color: :yellow,
        line: 0
      }
    }
  end
  # A method that returns the number of errors

  def total_error
    @errors.size
  end
  # A method that displays list of errors

  def valid_file?(file_path)
    FileReader.file_validator(file_path)
  end
end
# rubocop:enable Style/Documentation
