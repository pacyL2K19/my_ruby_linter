module CheckerModule
  def block?(line)
    if line.strip.start_with?('if', 'def', 'while', 'until', 'module', 'unless', 'class', 'elsif',
                              'else') || line.end_with?('do') || (line.end_with?('|') && !(/(do)(\s+)(\|)/ =~ self).nil?)
      return true
    end

    false
  end

  def check_parentesis(line)
    return false if line.count('(') != line.count(')')

    true
  end

  def check_brackets(line)
    return false if line.count('[') != line.count(']')

    true
  end

  def check_curly_brackets(line)
    return false if line.count('{') != line.count('}')

    true
  end
end

class String
  include CheckerModule
end
