module CheckerModule
  def block?
    if strip.start_with?('if', 'def', 'while', 'until', 'module', 'unless') || strip.end_with?('do') ||
       (strip.end_with?('|') && !(/(do)(\s+)(\|)/ =~ self).nil?)
      return true
    end

    false
  end

  def check_parentesis(line)
    return { error: :tag } if line.count('(') < line.count(')') || line.count('(') > line.count(')')
  end

  def check_brackets(line)
    return { error: :tag } if line.count('[') < line.count(']') || line.count('[') > line.count(']')
  end

  def check_curly_brackets(line)
    return { error: :tag } if line.count('{') < line.count('}') || line.count('{') > line.count('}')
  end

  def trailing_space_validate(_ret_arr, line, _index)
    return { error: :traillig_spaces } if line.end_with?(' ')
  end

  def empty_line_eof
    return { error: :empty_line } if @arr[-1].strip != ''
  end
end

class String
  include Linter_Module
end
