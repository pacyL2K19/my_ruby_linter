require 'colorize'
require_relative '../lib/checker'
require_relative '../lib/error_handler'

indentation = 2

puts 'Please put the path to the file to be checked'
file = gets.chomp
errors = FileReader.new(file)

if !errors.is_valid_file?
  puts errors.is_valid_file?(file)
else
  checker = Checker.new(File.readlines(file).map(&:chomp),indentation)
  puts ''

  if checker.line_indentation_errors != []
    puts 'Incorect Indentation'
  end
  if answer == 'Y'
    checker.indentation_autocorrect
    File.open(file, 'w') do |f|
      checker.arr.each do |n|
        f.puts n
      end
    end
  end
  checker.validate
  errors = ErrorHandler.new(checker.missing_parenthesis,
                            checker.trailing_space_errors,
                            checker.multiple_empty_lines_errors,
                            checker.block_errors,
                            checker.empty_line_eof_errors,
                            checker.line_indentation_errors,
                            checker.block_not_closed)
  puts "YOU HAVE #{errors.total_errors} ERRORS AND WARNING TO BE FIXED IN YOUR FILE".colorize(:color => "red")
end