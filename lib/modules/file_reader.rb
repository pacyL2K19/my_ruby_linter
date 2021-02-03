module FileReader
  def file_validator(file_path)
    danger = :red
    warning = :yellow
    unless File.exist?(file_path)
      return ' The specified file does not exist, please enter a correct one '
    end
    unless File.extname(file_path) == '.rb'
      return ' The file extension is not allowed, please put a .rb file to be checked '
    end
    return ' This file is empty ' if File.zero?(file_path)

    true
  end
end
