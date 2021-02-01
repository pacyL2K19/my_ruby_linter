require 'colorize'
require_relative '../lib/checker'
require_relative '../lib/error_handler'
require_relative '../lib/modules/file_reader'
include FileReader

indentation = 2

puts 'Please put the path to the file to be checked'
file = gets.chomp
# errors = FileReader.new(file)
errorHandler = ErrorHandler.new()

if errorHandler.valid_file?(file) != true
  puts errorHandler.valid_file?(file)
else
  checker = Checker.new(File.readlines(file).map(&:chomp), indentation)
  puts ''

  checker.validate(errorHandler)
  checker.check_indentation(errorHandler)
  checker.empty_line_eof(errorHandler)
  checker.lines.times do |i|
    checker.trailing_space(errorHandler, checker.lines[i], i)
    checker.multiple_empty_lines(errorHandler, checker.lines[i], i)
    checker.parenthesis(errorHandler, checker.lines[i], i)
  end

  message = ""

  if errorHandler.errors.size == 0 && errorHandler.warnings.size == 0
    message = "0 ERROR 0 WARNING FOUND IN YOUR FILE".colorize(color: :green)
  elsif errorHandler.errors.size == 0
    message = "0 ERROR FOUND IN YOUR CODE, #{errorHandler.warnings.size} WARNING FOUND".colorize(color: :yellow)
  else
    message = "#{errorHandler.errors.size} ERRORS FOUND IN YOUR FILE NEED TO BE FIXED, #{error_handler.warnings.size} WARNINGS FOUND".colorize(color: :red)
  end

  puts message

  # puts 'Incorect Indentation' if checker.line_indentation_errors != []
  # if answer == 'Y'
  #   checker.indentation_autocorrect
  #   File.open(file, 'w') do |f|
  #     checker.arr.each do |n|
  #       f.puts 
  #     endn
  #   end
  # end
  # checker.validate
  # errors = ErrorHandler.new(checker.missing_parenthesis,
  #                           checker.trailing_space_errors,
  #                           checker.multiple_empty_lines_errors,
  #                           checker.block_errors,
  #                           checker.empty_line_eof_errors,
  #                           checker.line_indentation_errors,
  #                           checker.block_not_closed)
  # puts "YOU HAVE #{errors.total_errors} ERRORS AND WARNING TO BE FIXED IN YOUR FILE".colorize(color: 'red')
end
