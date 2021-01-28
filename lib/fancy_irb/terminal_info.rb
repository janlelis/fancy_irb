require 'io/console'

module FancyIrb
  module TerminalInfo
    def self.lines
      STDOUT.winsize[0]
    rescue Errno::ENOTTY
      ENV['LINES'] || ENV['ROWS'] || 25
    end

    def self.cols
      STDOUT.winsize[1]
    rescue Errno::ENOTTY
      ENV['COLUMNS'] || 80
    end

    begin
      if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
        TPUT = {
          :sc   => "\e[s",
          :rc   => "\e[u",
          :cuu1 => "\e[1A",
          :cuf1 => "\e[1C",
        }
      elsif RbConfig::CONFIG['host_os'] =~ /linux(?!-musl)/
        TPUT = {
          :sc   => `script -q -e -t /dev/null -c 'tput sc'`,
          :rc   => `script -q -e -t /dev/null -c 'tput rc'`,
          :cuu1 => `script -q -e -t /dev/null -c 'tput cuu1'`,
          :cuf1 => `script -q -e -t /dev/null -c 'tput cuf1'`,
        }
      else
        TPUT = {
          :sc   => `tput sc`,
          :rc   => `tput rc`,
          :cuu1 => `tput cuu1`,
          :cuf1 => `tput cuf1`,
        }
      end
    rescue Errno::ENOTTY
      TPUT = {
        :sc   => "\e7",
        :rc   => "\e8",
        :cuu1 => "\e[A",
        :cuf1 => "\e[C",
      }
    end
  end
end
