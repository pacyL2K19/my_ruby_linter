module Checker_Module
  def is_block?
    if strip.start_with?('if', 'def', 'while', 'until', 'module', 'unless') || strip.end_with?('do') ||
      (strip.end_with?('|') && !(/(do)(\s+)(\|)/ =~ self).nil?)
      return true
    end
    false
  end

  def check_parentesis(line)
    return {:error => :tag} if line.count('(') < line.count(')') || line.count('(') > line.count(')')
  end

  def check_brackets(line)
    return {:error => :tag} if line.count('[') < line.count(']') || line.count('[') > line.count(']')
  end

  def check_curly_brackets(line)
    return {:error => :tag} if line.count('{') < line.count('}') || line.count('{') > line.count('}')
  end
  def check_white_space(line)
    return {:error => :traillig_spaces} if line.end
  end
  def check_empty_line(line)
    return {:error => :empty_space} if line.eql?('')
  end
end

class String
  include Linter_Module
end