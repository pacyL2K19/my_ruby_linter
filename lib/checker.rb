require 'colorize'
require_relative './modules/checker_module'
require_relative './modules/file_reader'
class Checker
  include CheckerModule
  attr_reader :lines, :indentation

  def initialize(lines, indentation)
    @lines = lines
    @indentation = indentation
    reset
  end

  def validate(error_handler)
    empty_line_eof(error_handler)
    check_indentation(error_handler)
    @lines.each_with_index do |n, i|
      parenthesis(error_handler, n, i)
      trailing_space(error_handler, n, i)
      multiple_empty_lines(error_handler, n, i)
    end
  end

  # rubocop:disable Layout/LineLength

  def check_indentation(error_handler)
    count = 0
    @lines.each_with_index do |line, index|
      if count.zero?
        error_handler.catch_err_warn('warning', "should have #{@indentation} spaces", index + 1) if line.gsub(' ', '-').split('-')[0] == ''
      else
        puts 'here'
        error_handler.catch_err_warn('warning', "should have #{@indentation * count} spaces", index + 1) unless line.strip == '' || (line.strip == 'end' && line.gsub(' ', '-').start_with?('-' * (count * @indentation)) && line.gsub(' ', '-').split('')[count * @indentation] != '-') || (line.gsub(' ', '-').start_with?('-' * (count * @indentation)) && line.gsub(' ', '-').split('')[count * @indentation] != '-')
        puts " line #{index} "
        puts count
        puts line.gsub(' ', '-').start_with?('-' * (count * @indentation))
      end
      count += 1 if block?(line)
      count -= 1 if line.strip == 'end' || !block?(line)
      count = 0 if count.negative?
    end
  end

  # rubocop:enable Layout/LineLength

  private

  def reset
    @errors = []
    @warning = []
  end

  public

  def trailing_space(error_handler, line, index)
    error_handler.catch_err_warn('error', 'ends with trailing space', index + 1) if line.end_with?(' ')
  end

  def multiple_empty_lines(error_handler, line, index)
    error_handler.catch_err_warn('error', 'preceded by another empty line', index + 1) if line == '' && @lines[index - 1] == ''
  end

  def parenthesis(error_handler, line, index)
    error_handler.catch_err_warn('error', 'you have an odd number of parenthesis', index + 1) unless check_parentesis(line)
    error_handler.catch_err_warn('error', 'you have an odd number of brackets', index + 1) unless check_brackets(line)
    error_handler.catch_err_warn('error', 'you have an odd number of curly brackets', index + 1) unless check_curly_brackets(line)
  end

  def empty_line_eof(error_handler)
    error_handler.catch_err_warn('warning', 'File should have an empty line at the end', @lines.size) if @lines[-1].strip != ''
  end
end
