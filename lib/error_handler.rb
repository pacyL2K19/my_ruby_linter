require_relative './modules/file_reader'
class ErrorHandler
  include FileReader

  attr_reader :errors, :warnings

  def initialize
    @errors = []
    @warnings = []
  end
  # A method that returns the number of errors

  def total_error
    @errors.size
  end
  # A method that returns the number of warnings

  def total_warning
    @warnings.size
  end
  # A method to catch new error or warning

  def catch_err_warn(type, message, line)
    color = type == 'error' ? :red : :yellow
    new_error= {
      :type => type,
      :color => color,
      :message => message,
      :line => line
    }
    if type == 'error'
      @errors << new_error
    elsif type == 'warning'
      @warnings << new_error
    end
  end

  def valid_file?(file_path)
    FileReader.file_validator(file_path)
  end
end
