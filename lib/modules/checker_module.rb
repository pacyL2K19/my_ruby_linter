module CheckerModule
  def block?
    if strip.start_with?('if', 'def', 'while', 'until', 'module', 'unless') || strip.end_with?('do') ||
       (strip.end_with?('|') && !(/(do)(\s+)(\|)/ =~ self).nil?)
      return true
    end

    false
  end

  def check_parentesis(line)
    return false if line.count('(') != line.count(')')
    return true
  end

  def check_brackets(line)
    return false if line.count('[') != line.count(']')
    return true
  end

  def check_curly_brackets(line)
    return false if line.count('{') != line.count('}')
    return true
  end

  def trailing_space_validate(_ret_arr, line, _index)
    return false if line.end_with?(' ')
    return false
  end

  def empty_line_eof
    return false if @arr[-1].strip != ''
    return false
  end
end

class String
  include CheckerModule
end
