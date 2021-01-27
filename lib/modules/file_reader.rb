require 'colorize'
module FileReader
  def file_validator(file_path)
    return "The specified file does not exist, pleqse enter a correct one" unless File.exist?(file_path)
    return "The file extension is not allowed, please put a .rb file to be checked" unless File.extname == ".rb"
    return "This file is empty" unless File.zero?(file_path)
    true
  end
end