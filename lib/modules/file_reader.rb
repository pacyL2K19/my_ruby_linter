require 'colorize'
module FileReader
  def file_validator(file_path)
    # p "One"
    return " The specified file does not exist, pleqse enter a correct one ".colorize(:color => :white, :background => :red) unless File.exist?(file_path)
    # p "two"
    return " The file extension is not allowed, please put a .rb file to be checked ".colorize(:color => :white, :background => :red) unless File.extname(file_path) == ".rb"
    # p "Three"
    return " This file is empty ".colorize(:color => :white, :background => :red) unless File.zero?(file_path)
    # p "four"
    # File.size(file_path)
    return true
  end
end