require 'colorize'
require_relative '../lib/checker'
require_relative '../lib/error_handler'
require_relative '../lib/modules/file_reader'

# rubocop:disable Style/MixinUsage
# rubocop:disable Layout/LineLength

include FileReader

indentation = 2

puts 'Please put the path to the file to be checked'

file = gets.chomp

error_handler = ErrorHandler.new

if error_handler.valid_file?(file) != true
  puts error_handler.valid_file?(file).colorize(color: :white, background: :red)
else
  checker = Checker.new(File.readlines(file).map(&:chomp), indentation)
  puts ''
  checker.validate(error_handler)
  message = ''

  if error_handler.errors.size.zero? && error_handler.warnings.size.zero?
    message = '0 ERROR 0 WARNING FOUND IN YOUR FILE'.colorize(color: :green)
  elsif error_handler.errors.size.zero?
    message = "0 ERROR FOUND IN YOUR CODE, #{error_handler.warnings.size} WARNING FOUND".colorize(color: :yellow)
  else
    message = "#{error_handler.errors.size} ERRORS FOUND IN YOUR FILE NEED TO BE FIXED, #{error_handler.warnings.size} WARNINGS FOUND".colorize(color: :red)
  end

  error_handler.errors.each do |err|
    puts "[ #{err[:type].upcase} ] On the line #{err[:line]} #{err[:message]}".colorize(color: err[:color])
  end

  error_handler.warnings.each do |war|
    puts "[ #{war[:type].upcase} ] On the line #{war[:line]} #{war[:message]}".colorize(color: war[:color])
  end

  puts message

end
# rubocop:enable Style/MixinUsage
# rubocop:enable Layout/LineLength
