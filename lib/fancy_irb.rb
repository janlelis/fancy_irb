require_relative 'fancy_irb/version'

require 'stringio'
require 'paint'

require_relative 'fancy_irb/terminal_info'
require_relative 'fancy_irb/implementation'

module FancyIrb
  DEFAULT_RESULT_PROC = proc{ |context|
    if context.inspect?
      context.last_value.inspect
    else
      context.last_value
    end
  }

  DEFAULT_COLORIZER_PROC = proc{ |value|
    FancyIrb.real_lengths[:output] =    value.size
    if defined?(Wirb) && FancyIrb[:colorize, :output]
      Wirb.colorize_result value
    else
      value
    end
  }

  DEFAULT_OPTIONS = {
    :rocket_mode     => true,   # activate or deactivate #=> rocket output
    :rocket_prompt   => '#=> ', # prompt to use for the rocket
    :result_prompt   => '=> ',  # prompt to use for normal output
    :colorize => {              # colors hash. Set to nil to deactivate colorizing
      :rocket_prompt => [:blue],
      :result_prompt => [:blue],
      :input_prompt  => nil,
      :irb_errors    => [:red],
      :stderr        => [:red, :bright],
      :stdout        => nil,
      :input         => nil,
      :output        => true, # wirb's output colorization
     },
    :result_proc     => DEFAULT_RESULT_PROC,       # how to get the output result
    :output_procs    => [DEFAULT_COLORIZER_PROC],  # you can modify/enhance/log your output
    :east_asian_width => false, # set to true if you have double-width characters (slower)
  }

  DEACTIVATE_ROCKET = %w[
    system
    spawn
  ].map(&:to_sym)

  # TODO: each_byte, each_char, each_codepoint, each, etc
  STDIN_TRACK_HEIGHT_METHODS = %w[
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

  KERNEL_TRACK_HEIGHT_METHODS = %w[
    gets
  ].map(&:to_sym)
end

