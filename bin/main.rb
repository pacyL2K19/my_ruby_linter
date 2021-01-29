require 'colorize'
require_relative '../lib/checker'
require_relative '../lib/error_handler'

indentation = 2

puts 'Please put the path to the file to be checked'
file = gets.chomp
errors = ErrorHandler.new(file)

if !errors.is_valid_file?
  puts errors.is_valid_file?(file)
else
  checker = Checker.new(File.readlines(file).map(&:chomp),indentation)
  puts ''

  if checker.line_indentation_errors != []
    puts 'Incorect Indentation'
  end
  checker.validate(answer)
  errors = ErrorHandler.new(checker.missing_parenthesis,
                            checker.line_length_errors,
                            checker.trailing_space_errors,
                            checker.multiple_empty_lines_errors,
                            checker.operator_spacing_errors,
                            checker.block_errors,
                            checker.empty_line_eof_errors,
                            checker.line_indentation_errors,
                            checker.block_not_closed)
  puts "********** TOTAL ERRORS #{errors.total_errors} **********"
  puts ''
  puts ''
  puts errors.print_errors

  if (checker.trailing_space_errors.length + checker.operator_spacing_errors.length +
      checker.empty_line_eof_errors.length + checker.multiple_empty_lines_errors.length).positive?
    print 'Do you want to auto-correct the trailing white spaces,'
    puts ' spacing around operators, empty line at end of file and multiple empty lines errors? Y/n'
    answer = gets.chomp.upcase

    until %w[Y N].include?(answer)
      puts 'Please select Y/n. Do you want to autocorrect the mentioned errors?'
      answer = gets.chomp.upcase
    end

    if answer == 'Y'
      checker.indentation_autocorrect
      checker.autocorrect
      File.open(file, 'w') do |f|
        checker.arr.each do |n|
          f.puts n
        end
      end
      total_errors = errors.total_errors
      checker.validate(answer)
      errors = ErrorHandler.new(checker.missing_parenthesis,
                                checker.line_length_errors,
                                checker.trailing_space_errors,
                                checker.multiple_empty_lines_errors,
                                checker.operator_spacing_errors,
                                checker.block_errors,
                                checker.empty_line_eof_errors,
                                checker.line_indentation_errors,
                                checker.block_not_closed)
      puts ''
      puts ''
      puts "ERRORS BEFORE AUTO-CORRECT: #{total_errors}"
      puts "ERRORS CORRECTED: #{total_errors - errors.total_errors}"
      puts "********** NEW TOTAL ERRORS #{errors.total_errors}**********"
      puts ''
      puts ''
      puts errors.print_errors
    end
  end
end