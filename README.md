# FancyIrb

*   Colorizes prompts, errors, `stderr` and `stdout`
*   Uses Hash Rockets to display evaluation results
*   Allows you to apply a proc before showing the result


## Usage

    require 'fancy_irb'
    FancyIrb.start

You can pass an options hash. These are the default values:

    DEFAULT_OPTIONS = {
      :rocket_mode     => true,   # activate or deactivate #=> rocket output
      :rocket_prompt   => '#=> ', # prompt to use for the rocket
      :result_prompt   => '=> ',  # prompt to use for normal output
      :result_proc     => DEFAULT_RESULT_PROC,       # how to get the output result from IRB
      :output_procs    => [DEFAULT_COLORIZER_PROC],  # output formatter procs
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

Rocket mode means: Output result as comment if there is enough space left on
the terminal line and `stdout` does not output more than the current terminal
height.

For more information on which colors can be used, see the [paint
documentation](https://github.com/janlelis/paint).

## Example configurations
### Default
    FancyIrb.start

### No colorization
    FancyIrb.start :colorize => nil

### Use awesome_print for inspecting
    require 'ap'
    FancyIrb.start :rocket_mode   => false,
                   :colorize      => { :output => false,
                                       :result_prompt => :yellow },
                   :result_proc   => proc{ |context|
                                       context.last_value.awesome_inspect
                                     }

## Advanced: Hook into IRB
You can modify how to get and display the input. The `result_proc` is a proc
which takes the irb context object and should return the value. You can change
it with `FancyIrb.set_result_proc do (your code) end`. After that, each proc
in `output_procs` gets triggered. They take the value and can return a
modified one. You can use the `FancyIrb.add_output_proc` method for adding new
output filter procs.

### Default result_proc

    DEFAULT_RESULT_PROC = proc{ |context|
      if context.inspect?
        if defined?(context.last_value.inspect)
          context.last_value.inspect
        else
          "(Object doesn't support #inspect)"
        end
      else
        context.last_value
      end
    }

### Default colorizer_proc

    DEFAULT_COLORIZER_PROC = proc{ |value|
      if defined?(Wirb)
        Wirb.colorize_result value
      else
        value
      end
    }

## Troubleshooting
### Windows Support
You will need [ansicon](https://github.com/adoxa/ansicon).

### Wrong display widths?
When using double-width unicode chars, you should set `:east_asian_width` to
`true`. It is not activated by default, because of its performance impact.

### Known bugs
Not all stdin methods are patched properly to work with the rocket: The gems
focuses on the often used ones

## TODO
*   Refactor to modern code
*   Just count string lengths without ansi escape sequences (would be more
    flexible than remembering)


## J-_-L
Inspired by the irb_rocket gem by genki.

Copyright (c) 2010-2012, 2015 Jan Lelis <http://janlelis.com> released under
the MIT license.
