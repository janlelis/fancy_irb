require 'io/console'

module FancyIrb
  module TerminalInfo
    def self.lines
      STDOUT.winsize[0]
    end

    def self.cols
      STDOUT.winsize[1]
    end

    if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
      TPUT = {
        :sc   => "\e[s",
        :rc   => "\e[u",
        :cuu1 => "\e[1A",
        :cuf1 => "\e[1C",
      }
    else
      TPUT = {
        :sc   => `tput sc`,
        :rc   => `tput rc`,
        :cuu1 => `tput cuu1`,
        :cuf1 => `tput cuf1`,
      }
    end
  end
end
