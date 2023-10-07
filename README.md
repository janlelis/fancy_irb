# FancyIrb [![version](https://badge.fury.io/rb/fancy_irb.svg)](https://badge.fury.io/rb/fancy_irb)  [![[ci]](https://github.com/janlelis/fancy_irb/workflows/Test/badge.svg)](https://github.com/janlelis/fancy_irb/actions?query=workflow%3ATest)

*   Colorizes IRB prompts, errors, `$stderr` and `$stdout`
*   Uses "Hash Rockets" (#=>) to display IRB results

## Version 2.0 for Modern IRB

**Please note:** Version 2.0 of this gem requires Ruby 3 and IRB 1.7+

## Usage

    require 'fancy_irb'
    FancyIrb.start

You can pass an options hash as argument. These are the default values:

    DEFAULT_OPTIONS = {
      :rocket_mode     => true,       # activate or deactivate #=> rocket
      :rocket_prompt   => '#=> ',     # prompt to use for the rocket
      :result_prompt   => '=> ',      # prompt to use for normal output
      :colorize => {                  # colors hash. Set to nil to deactivate colors
        :rocket_prompt => [:blue],
        :result_prompt => [:blue],
        :input_prompt  => nil,
        :irb_errors    => [:red, :clean],
        :stderr        => [:red, :bright],
        :stdout        => nil,
        :input         => nil,
       },
    }

Rocket mode means: Instead of displaying the result on the next line, show it
on the same line (if there is enough space)

For more information on which colors can be used, see the [paint documentation](https://github.com/janlelis/paint).

## Troubleshooting
### Windows Support
You will need [ansicon](https://github.com/adoxa/ansicon) or [ConEmu](https://code.google.com/p/conemu-maximus5/) or [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

### Known Bugs
Not all methods dealing with input data are patched properly to work with the rocket,
the gem focuses on the commonly used ones, like `gets` or `getc`.

## J-_-L
Inspired by the irb_rocket gem by genki.

Copyright (c) 2010-2012, 2015-2023 Jan Lelis <https://janlelis.com> released under
the MIT license.
