class Mafti

  attr_accessor :lines
  attr_accessor :data
  attr_accessor :headers

  def initialize(new_lines=[])
    @lines    = new_lines
    @data     = []
    @headers  = []
    parse
  end

  def parse
    @lines.each_with_index do |line, n|
      line = line.strip 
      case line
      
      when /^$/                  # '' (empty line)
        next
      when /^#.*$/               # '# Foo bar baz!' (a comment)
        next
      when /^-+$/                # '---------------------' (divider)
        next
      when /^(\|[^\|]*)*\|$/     # '| Foo   | Bar   | Baz   |' (valid data)
        new_data = parse_valid_line(line)
        unless headers_recorded?
          @headers = new_data
        else
          @data   << new_data
        end
      else
        raise "Line #{n} was invalid: #{line}"
      end
    end
  end

  def as_hash
    @data.inject({}) do |hash, d|
      @headers.each do |head|  
        hash[head] = d.unshift 
      end
    end
  end

  def self.open(filename)
    f = File.open(filename)
    lines = f.readlines
    f.close
    Mafti.new(lines)
  end

  protected

  def parse_valid_line(line)
    line.split('|').reject { |x| x.empty? }.map(&:strip)
  end

  def headers_recorded?
    !@headers.empty?
  end

end
