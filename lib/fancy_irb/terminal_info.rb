if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
  unless ENV['ANSICON']
    raise LoadError, 'FancyIrb needs ansicon on windows, see https://github.com/adoxa/ansicon'
  end

  module FancyIrb
    module TerminalInfo
      TPUT = {
        :sc   => "\e[s",
        :rc   => "\e[u",
        :cuu1 => "\e[1A",
        :cuf1 => "\e[1C",
      }

      def self.cols
         ENV['ANSICON'][/\((.*)x/, 1].to_i
      end

      def self.lines
         ENV['ANSICON'][/\(.*x(.*)\)/, 1].to_i
      end
    end
  end

else

  module FancyIrb
    module TerminalInfo
      TPUT = {
        :sc   => `tput sc`,
        :rc   => `tput rc`,
        :cuu1 => `tput cuu1`,
        :cuf1 => `tput cuf1`,
      }

      def self.cols
       `tput cols`.to_i
      end

      def self.lines
       `tput lines`.to_i
      end
    end
  end

end
