require_relative 'fancy_irb/version'

require 'stringio'
require 'paint'

require_relative 'fancy_irb/terminal_info'
require_relative 'fancy_irb/size_detector'
require_relative 'fancy_irb/error_capturer'
require_relative 'fancy_irb/implementation'

module FancyIrb
  DEFAULT_OPTIONS = {
    :rocket_mode     => true,   # activate or deactivate #=> rocket output
    :rocket_prompt   => '#=> ', # prompt to use for the rocket
    :result_prompt   => '=> ',  # prompt to use for normal output
    :east_asian_width => false, # set to true if you have double-width characters (slower)
    :colorize => {              # colors hash. Set to nil to deactivate colors
      :rocket_prompt => [:blue],
      :result_prompt => [:blue],
      :input_prompt  => nil,
      :irb_errors    => [:red, :clean],
      :stderr        => [:red, :bright],
      :stdout        => nil,
      :input         => nil,
     },
  }

  SKIP_ROCKET_METHODS = %w[
    system
    spawn
  ].map(&:to_sym)

  # TODO: each_byte, each_char, each_codepoint, each, etc
  TRACK_HEIGHT_INPUT_METHODS = %w[
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
  ].map(&:to_sym)
end

