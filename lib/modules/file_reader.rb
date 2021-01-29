# frozen_string_literal: true
# rubocop:disable Metrics/MethodLength

require 'colorize'
module FileReader
  def file_validator(file_path)
    danger = :red
    unless File.exist?(file_path)
      return ' The specified file does not exist, pleqse enter a correct one '.colorize(color: :white,
                                                                                        background: danger)
    end
    unless File.extname(file_path) == '.rb'
      return ' The file extension is not allowed, please put a .rb file to be checked '.colorize(color: :white,
                                                                                                 background: danger)
    end
    return ' This file is empty '.colorize(color: :white, background: danger) unless File.zero?(file_path)

    true
  end
end
# rubocop:enable Metrics/MethodLength
