require_relative './modules/checker_module'
require_relative './modules/file_reader'
require_relative './error_handler'

class Checker
  include CheckerModule
  # errorHolder = ErrorHandler.new()

  attr_reader :lines

  def initialize(lines, indentation)
    @lines = lines
    @indentation = indentation
    check_indentation
  end

  def validate
    empty_line_eof
    @lines.each_with_index do |n, i|
      parenthesis(@missing_parenthesis, n, i)
      trailing_space_validate(@trailing_space_errors, n, i)
      multiple_empty_lines_validate(@multiple_empty_lines_errors, n, i)
    end
    block_length
  end

  # rubocop:disable Layout/LineLength

  def check_indentation(errHolder)
    count = 0
    @lines.each_with_index do |line, index|
      errHolder.catch_err_warn("warning", "should have #{count * @indentation} spaces", index+1) unless line.start_with?(' ' * (count * @indentation)) || line.strip == '' || (line.strip == 'end' && line.start_with?(' ' * [0, (count - 1)].max * @indentation))
    end
  end

  # rubocop:enable Layout/LineLength

  private

  def reset
    @errors = []
    @warning = []
  end

  # def block_dictionary_creator(ret, line, index)
  #   if line.block?
  #     ret << [index + 1, (line.length - line.lstrip.length) / @indentation]
  #   elsif line.include?('end')
  #     ret.reverse.each do |m|
  #       if m.length == 2 && ((line.length - line.lstrip.length) / @indentation) == m[1]
  #         m << (index + 1)
  #         break
  #       end
  #     end
  #   end
  #   ret
  # end
  # rubocop:disable Style/GuardClause

  def trailing_space_validate(errHolder, line, index)
    errHolder.catch_err_warn("error", "ends with trailing space", index+1) if line.end_with?(' ')
  end

  def multiple_empty_lines_validate(errorHolder, line, index)
    errHolder.catch_err_warn("error", "preceded by another empty line", index+1) if line == '' && @lines[index - 1] == ''
  end

  def parenthesis(errHandler, war, line, index)
    if parenthesis_even(line) != true
      errHolder.catch_err_warn("error", "you have an odd number of parenthesis", index+1)
    end
    if brackets_even(line) != true
      errHolder.catch_err_warn("error", "you have an odd number of brackets", index+1)
    end
    unless curly_brackets_even(line) != true
      errHandler.catch_err_warn("error", "you have an odd number of curly brackets", index+1)
    end
  end
  # rubocop:enable Style/GuardClause

  def empty_line_eof(errHandler)
    errHandler.catch_err_warn("warning", "File should have an empty line at the end", 0)
  end

  # def block_length
  #   @block_dictionary.each do |block|
  #     if block.length < 3
  #       @block_not_closed << "Block starting on line #{block[0]} is not closed"
  #     end
  #   end
  # end
end
