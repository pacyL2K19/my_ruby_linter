require_relative '../lib/checker'
require_relative '../lib/error_handler'

describe Checker do
  let(:checker) { Checker.new(File.readlines('test_bug.rb').map(&:chomp), 2) }
  # let(:error_handler) {ErrorHandler.new}

  # the validate method it self contains all the methods
  describe '#validate' do
    let(:error_handler) { ErrorHandler.new }
    it 'returns an array which contains a the list of all the errors and warning' do
      expect(checker.validate(error_handler).errors.length).to eql(4)
    end
    it 'contains errors and warnings, their lenght are not supposed to be zero' do
      expect(checker.validate(error_handler).errors.size + checker.validate(error_handler).warnings.size).not_to eql(0)
    end
  end
  describe '#check_indentation' do
    let(:error_handler) { ErrorHandler.new }
    it 'Checks indentation of two lines for each lines and return an object with errors' do
      expect(checker.check_indentation(error_handler).warnings.size).not_to eql(0)
    end
    it 'Indentation issues are concidered as warnings not error, the check indentation method only returns warnings' do
      expect(checker.check_indentation(error_handler).errors.size).to eq(0)
    end
  end
end
