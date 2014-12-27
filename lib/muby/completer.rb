module Muby

  class Completer

    attr_reader :completions
    
    def initialize
      @completions = {}
    end

    @@instance = Muby::Completer.new

    def self.get_instance
      @@instance
    end

    def complete(s)
      subhash = find_subhash(s, @completions) || {}
      find_endings(s, subhash)
    end
    
    def store(s)
      s.split(/\W+/).each do |part|
        store_in_hash(part, @completions) unless part.empty?
      end
    end

    def find_endings(s, hash)
      return_value = []
      hash.each do |char, value|
        if char == :end
          return_value << s
        else
          return_value |= find_endings(s + char, value)
        end
      end
      return_value
    end

    def find_subhash(s, hash)
      return {} if hash.nil?
      if s.size == 0
        hash
      else
	rval = find_subhash(s[1..-1], hash[s[0..0]])
	rval.merge(find_subhash(s[1..-1], hash[s[0..0].swapcase]))
      end
    end

    def store_in_hash(s, hash)
      if s.size == 1
        hash[s] ||= {}
        hash[s][:end] = true
      else
        hash[s[0..0]] ||= {}
        store_in_hash(s[1..-1], hash[s[0..0]])
      end
    end

  end

end
