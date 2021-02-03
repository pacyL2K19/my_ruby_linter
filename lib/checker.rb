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

  def validate(errHandler)
    empty_line_eof(errHandler)
    check_indentation(errHandler)
    @lines.each_with_index do |n, i|
      parenthesis(errHandler, n, i)
      trailing_space(errHandler, n, i)
      multiple_empty_lines(errHandler, n, i)
    end
  end

  # rubocop:disable Layout/LineLength

  def check_indentation(errHolder)
    count = 0
    @lines.each_with_index do |line, index|
      if count == 0
        errHolder.catch_err_warn("warning", "should have #{@indentation} spaces", index+1) if line.gsub(" ", "-").split("-")[0] == ""
      else
        puts "here"
        errHolder.catch_err_warn("warning", "should have #{@indentation * count} spaces", index+1) unless line.strip == '' || (line.strip == 'end' && line.gsub(" ", "-").start_with?('-' * (count * @indentation)) && line.gsub(" ", "-").split("")[count * @indentation] != "-") || (line.gsub(" ", "-").start_with?("-" * (count * @indentation)) && line.gsub(" ", "-").split("")[count * @indentation] != "-")
        #|| line.strip == '' || (line.strip == 'end' && line.start_with?(' ' * [0, (count - 1)].max * @indentation))
        # puts line.gsub(" ", "-").start_with?("-" * (count * @indentation))
        puts " line #{index} "
        puts count
        puts line.gsub(" ", "-").start_with?('-' * (count * @indentation))
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
  public
  def trailing_space(errHolder, line, index)
    errHolder.catch_err_warn("error", "ends with trailing space", index+1) if line.end_with?(' ')
  end

  public
  def multiple_empty_lines(errorHolder, line, index)
    errHolder.catch_err_warn("error", "preceded by another empty line", index+1) if line == '' && @lines[index - 1] == ''
  end

  public
  def parenthesis(errHandler, line, index)
    if !check_parentesis(line)
      errHandler.catch_err_warn("error", "you have an odd number of parenthesis", index+1)
    end
    if !check_brackets(line)
      errHandler.catch_err_warn("error", "you have an odd number of brackets", index+1)
    end
    if !check_curly_brackets(line)
      errHandler.catch_err_warn("error", "you have an odd number of curly brackets", index+1)
    end
  end
  # rubocop:enable Style/GuardClause

  def empty_line_eof(errHandler)
    errHandler.catch_err_warn("warning", "File should have an empty line at the end", @lines.size) if @lines[-1].strip != ''
  end

  # def block_length
  #   @block_dictionary.each do |block|
  #     if block.length < 3
  #       @block_not_closed << "Block starting on line #{block[0]} is not closed"
  #     end
  #   end
  # end
end
