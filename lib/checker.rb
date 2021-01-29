require_relative './modules/checker_module'
require_relative './modules/file_reader'
class Checker
  include Linter

  attr_reader :block_not_closed, :operator_spacing_errors, :empty_line_eof_errors, :line_indentation_errors, :arr, :block_dictionary, :missing_parenthesis, :block_errors, :trailing_space_errors

  def initialize(arr, indentation)
    @arr = arr
    @indentation = indentation
    @block_dictionary = []
    @missing_parenthesis = []
    @line_length_errors = []
    @block_errors = []
    @trailing_space_errors = []
    @multiple_empty_lines_errors = []
    @line_indentation_errors = []
    @empty_line_eof_errors = []
    @block_not_closed = []
    check_indentation
  end

  def validate(answer)
    empty_line_eof
    @line_indentation_errors = [] if answer == 'Y'
    @arr.each_with_index do |n, i|
      parenthesis(@missing_parenthesis, n, i)
      line_length_validate(@line_length_errors, n, i)
      trailing_space_validate(@trailing_space_errors, n, i)
      multiple_empty_lines_validate(@multiple_empty_lines_errors, n, i)
      space_around_operators(@operator_spacing_errors, n, i)
      block_dictionary_creator(@block_dictionary, n, i) if answer == 'Y'
    end
    block_length
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Layout/LineLength

  def check_indentation
    count = 0
    @arr.each_with_index do |line, index|
      @line_indentation_errors << "Line #{index + 1} should have #{count * @indentation} spaces" unless line.start_with?(' ' * (count * @indentation)) || line.strip == '' || (line.strip == 'end' && line.start_with?(' ' * [0, (count - 1)].max * @indentation))
      count += 1 if line.block?
      count -= 1 if line.strip == 'end'
    end
    @line_indentation_errors
  end

  # def indentation_autocorrect
  #   count = 0
  #   @arr.each_with_index do |line, index|
  #     if line.strip == 'end'
  #       (@arr[index] = (' ' * ([0, (count - 1)].max * @indentation)) + line.lstrip)
  #     elsif line.strip == ''
  #       @arr[index] = ''
  #     elsif line != '' || line.strip != 'end'
  #       (@arr[index] = (' ' * (count * @indentation)) + line.lstrip)
  #     end
  #     count += 1 if line.block?
  #     count -= 1 if line.strip == 'end'
  #   end
  #   @arr
  # end

  # def autocorrect
  #   dummy = []
  #   @arr.each_with_index do |line, index|
  #     @arr[index] = line.rstrip
  #     @arr.delete_at(index) while @arr[index].strip == '' && @arr[index + 1] == ''
  #     space_around_operators(dummy, line, index) do |n|
  #       @arr[index].insert(n[1] + 1, ' ') if n[1].positive?
  #       @arr[index].insert(n[2] + 1, ' ') if n[2].positive? && n[1].positive?
  #       @arr[index].insert(n[2], ' ') if n[2].positive? && n[1].negative?
  #     end
  #   end
  #   @arr << '' unless @empty_line_eof_errors.empty?
  #   reset
  # end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
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

  def block_dictionary_creator(ret_arr, line, index)
    if line.block?
      ret_arr << [index + 1, (line.length - line.lstrip.length) / @indentation]
    elsif line.include?('end')
      ret_arr.reverse.each do |m|
        if m.length == 2 && ((line.length - line.lstrip.length) / @indentation) == m[1]
          m << (index + 1)
          break
        end
      end
    end
    ret_arr
  end
  # rubocop:disable Style/GuardClause

  def line_length_validate(ret_arr, line, index)
    if line.length >= @line_length
      ret_arr << ["Line #{index + 1} doesn't satisfy the maximum line length of #{@line_length}"]
    end
  end

  def trailing_space_validate(ret_arr, line, index)
    ret_arr << ["Line #{index + 1} ends with trailing space"] if line.end_with?(' ')
  end

  def multiple_empty_lines_validate(ret_arr, line, index)
    ret_arr << ["Line #{index + 1} is preceded by another empty line"] if line == '' && @arr[index - 1] == ''
  end

  def parenthesis(ret_arr, line, index)
    unless parenthesis_even(line).nil?
      ret_arr << "Line #{index + 1} has more '#{parenthesis_even(line)[1]}' than '#{parenthesis_even(line)[0]}'"
    end
    unless brackets_even(line).nil?
      ret_arr << "Line #{index + 1} has more '#{brackets_even(line)[1]}' than '#{brackets_even(line)[0]}'"
    end
    unless curly_brackets_even(line).nil?
      ret_arr << "Line #{index + 1} has more '#{curly_brackets_even(line)[1]}' than '#{curly_brackets_even(line)[0]}'"
    end
  end
  # rubocop:enable Style/GuardClause

  def empty_line_eof
    @empty_line_eof_errors << 'File should end with an empty line' if @arr[-1].strip != ''
  end

  def space_around_operators(ret_arr, line, index)
    arr = operator_validator(line)
    arr.each_with_index do |n, i|
      arr[i] = yield(n) if block_given?
      ret_arr << "Line #{index + 1} has wrong spacing around operator #{n[0]}" unless n[1] == -1 && n[2] == -1
    end
  end

  def block_length
    @block_dictionary.each do |block|
      if block.length < 3
        @block_not_closed << "Block starting on line #{block[0]} is not closed"
      elsif @arr[block[0] - 1].start_with?('class') && block[2] - block[0] > @class_length
        @block_errors << "Block starting at #{block[0]} doesn't satisfy the maximum class length of #{@class_length}"
      elsif block[2] - block[0] > @block_length
        @block_errors << "Block starting at #{block[0]} doesn't satisfy the maximum block length of #{@class_length}"
      end
    end
  end
end