require 'colorize'
require_relative '../lib/checker'
require_relative '../lib/error_handler'
require_relative '../lib/modules/file_reader'

include FileReader

indentation = 2

puts 'Please put the path to the file to be checked'

file = gets.chomp

errorHandler = ErrorHandler.new()

if errorHandler.valid_file?(file) != true
  puts errorHandler.valid_file?(file)
else
  checker = Checker.new(File.readlines(file).map(&:chomp), indentation)
  puts ''
  checker.validate(errorHandler)
  message = ""

  if errorHandler.errors.size == 0 && errorHandler.warnings.size == 0
    message = "0 ERROR 0 WARNING FOUND IN YOUR FILE".colorize(color: :green)
  elsif errorHandler.errors.size == 0
    message = "0 ERROR FOUND IN YOUR CODE, #{errorHandler.warnings.size} WARNING FOUND".colorize(color: :yellow)
  else
    message = "#{errorHandler.errors.size} ERRORS FOUND IN YOUR FILE NEED TO BE FIXED, #{errorHandler.warnings.size} WARNINGS FOUND".colorize(color: :red)
  end

  errorHandler.errors.each do |err|
    puts "[ #{err[:type].upcase} ] On the line #{err[:line]} #{err[:message]}".colorize(color: err[:color])
  end

  errorHandler.warnings.each do |war|
    puts "[ #{war[:type].upcase} ] On the line #{war[:line]} #{war[:message]}".colorize(color: war[:color])
  end

  puts message

end
