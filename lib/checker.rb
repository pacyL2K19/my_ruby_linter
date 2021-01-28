require_relative './modules/checker_module'
require_relative './modules/file_reader'
class Checker
  include Checker_Module
  include FileReader
  def initialize
    
  end
end