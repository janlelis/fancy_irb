# FancyIrb [![version](https://badge.fury.io/rb/fancy_irb.svg)](http://badge.fury.io/rb/fancy_irb)

*   Colorizes IRB prompts, errors, `$stderr` and `$stdout`
*   Uses "Hash Rockets" (# =>) to display IRB results


## Usage

    require 'fancy_irb'
    FancyIrb.start

You can pass an options hash. These are the default values:

    DEFAULT_OPTIONS = {
      :rocket_mode     => true,   # activate or deactivate #=> rocket
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

Rocket mode means: Output result as comment if there is enough space left on
the terminal line and `stdout` does not output more than the current terminal
height.

For more information on which colors can be used, see the [paint
documentation](https://github.com/janlelis/paint).


## Troubleshooting
### Windows Support
You will need [ansicon](https://github.com/adoxa/ansicon) or [ConEmu](https://code.google.com/p/conemu-maximus5/).

### Wrong display widths?
When using double-width unicode chars, you should set `:east_asian_width` to
`true`. It is not activated by default, because of its performance impact.

### Known bugs
Not all stdin methods are patched properly to work with the rocket: The gems
focuses on the often used ones


## J-_-L
Inspired by the irb_rocket gem by genki.

Copyright (c) 2010-2012, 2015 Jan Lelis <http://janlelis.com> released under
the MIT license.
