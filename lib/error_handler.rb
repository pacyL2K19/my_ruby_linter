require_relative './modules/file_reader.rb'

class ErrorHandler
  def initialize
    @errors = []
    @error_messages = {
        :indentation => {
            :err_message => "Identation errors",
            :type => "error",
            :color => :red
        },
        :traillig_spaces => {
            :err_message => "Trailling unecessary white space error",
            :type => "error",
            :color => :red
        },
        :tag => {
            :err_message => "Missing or unexpected tag",
            :type => "error",
            :color => :red
        },
        :bloc => {
            :err_message => "Bloc not closed error",
            :type => "error",
            :color => :red
        },
        :empty_space => {
            :err_message => "Empty space error in your code",
            :type => "warning",
            :color => :yellow
        }
    }
  end
end
