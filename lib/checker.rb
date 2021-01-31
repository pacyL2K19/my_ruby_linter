require_relative './modules/checker_module'
require_relative './modules/file_reader'
require_relative './error_handler'
class Checker
  include CheckerModule

  attr_reader :lines

  def initialize(lines, indentation)
    @lines = lines
    @indentation = indentation
    check_indentation
  end

  def validate(_answer)
    empty_line_eof
    @lines.each_with_index do |n, i|
      parenthesis(@missing_parenthesis, n, i)
      trailing_space_validate(@trailing_space_errors, n, i)
      multiple_empty_lines_validate(@multiple_empty_lines_errors, n, i)
    end
    block_length
  end

  # rubocop:disable Layout/LineLength

  def check_indentation
    count = 0
    @lines.each_with_index do |line, index|

      # @line_indentation_errors << "Line #{index + 1} should have #{count * @indentation} spaces" unless line.start_with?(' ' * (count * @indentation)) || line.strip == '' || (line.strip == 'end' && line.start_with?(' ' * [0, (count - 1)].max * @indentation))
      # count += 1 if line.block?
      # count -= 1 if line.strip == 'end'
    end
    @line_indentation_errors
  end

  # rubocop:enable Layout/LineLength

  private

  def reset
    @missing_parenthesis = []
    @line_length_errors = []
    @block_errors = []
    @trailing_space_errors = []
    @multiple_empty_lines_errors = []
    @line_indentation_errors = []
    @empty_line_eof_errors = []
    @block_dictionary = []
    @block_not_closed = []
  end

  def block_dictionary_creator(ret, line, index)
    if line.block?
      ret << [index + 1, (line.length - line.lstrip.length) / @indentation]
    elsif line.include?('end')
      ret.reverse.each do |m|
        if m.length == 2 && ((line.length - line.lstrip.length) / @indentation) == m[1]
          m << (index + 1)
          break
        end
      end
    end
    ret
  end
  # rubocop:disable Style/GuardClause

  def line_length_validate(ret, line, index)
    ret << ["Line #{index + 1} doesn't satisfy the maximum line length of #{@line_length}"] if line.length >= @line_length
  end

  def trailing_space_validate(ret, line, index)
    ret << ["Line #{index + 1} ends with trailing space"] if line.end_with?(' ')
  end

  def multiple_empty_lines_validate(ret, line, index)
    ret << ["Line #{index + 1} is preceded by another empty line"] if line == '' && @arr[index - 1] == ''
  end

  def parenthesis(ret, line, index)
    unless parenthesis_even(line).nil?
      ret << "Line #{index + 1} has more '#{parenthesis_even(line)[1]}' than '#{parenthesis_even(line)[0]}'"
    end
    unless brackets_even(line).nil?
      ret << "Line #{index + 1} has more '#{brackets_even(line)[1]}' than '#{brackets_even(line)[0]}'"
    end
    unless curly_brackets_even(line).nil?
      ret << "Line #{index + 1} has more '#{curly_brackets_even(line)[1]}' than '#{curly_brackets_even(line)[0]}'"
    end
  end
  # rubocop:enable Style/GuardClause

  def empty_line_eof
    @empty_line_eof_errors << 'File should end with an empty line' if @arr[-1].strip != ''
  end

  def space_around_operators(ret, line, index)
    lines = operator_validator(line)
    lines.each_with_index do |n, i|
      lines[i] = yield(n) if block_given?
      ret << "Line #{index + 1} has wrong spacing around operator #{n[0]}" unless n[1] == -1 && n[2] == -1
    end
  end

  def block_length
    @block_dictionary.each do |block|
      if block.length < 3
        @block_not_closed << "Block starting on line #{block[0]} is not closed"
      elsif @lines[block[0] - 1].start_with?('class') && block[2] - block[0] > @class_length
        @block_errors << "Block starting at #{block[0]} doesn't satisfy the maximum class length of #{@class_length}"
      elsif block[2] - block[0] > @block_length
        @block_errors << "Block starting at #{block[0]} doesn't satisfy the maximum block length of #{@class_length}"
      end
    end
  end
end
