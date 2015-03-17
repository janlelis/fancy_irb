require_relative 'fancy_irb/version'

require 'stringio'
require 'paint'

require_relative 'fancy_irb/terminal_info'
require_relative 'fancy_irb/implementation'

module FancyIrb
  # TODO: each_byte, each_char, each_codepoint, each, etc
  STDIN_HOOKS = %w[
    binread
    read
    gets
    getc
    getbyte
    readbyte
    readchar
    readline
    readlines
    readpartial
    sysread
  ]
end

