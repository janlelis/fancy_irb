module IRB
  class Irb
    def output_value
      # prepare prompts
      rocket    = FancyIrb.colorize \
          FancyIrb[:rocket_prompt], FancyIrb[:colorize, :rocket_prompt]
      no_rocket = FancyIrb.colorize \
          FancyIrb[:result_prompt], FancyIrb[:colorize, :result_prompt]

      # get_result and pass it into every format_output_proc
      result = FancyIrb[:result_proc][ @context ]

      output = Array( FancyIrb[:output_procs] ).
        inject( result.to_s ){ |output, formatter|
          formatter[ output ].to_s
        }

      # reset color
      print Paint::NOTHING

      # try to output in rocket mode (depending on rocket_mode setting)
      if FancyIrb[:rocket_mode] && !FancyIrb.skip_next_rocket
        # get lengths
        last_input               = @scanner.instance_variable_get( :@line )
        last_line_without_prompt = last_input.split("\n").last
        offset =  + FancyIrb.real_lengths[:input_prompt] + 1
        if last_line_without_prompt
          offset += last_line_without_prompt.display_size
        end
        screen_length = FancyIrb::TerminalInfo.cols
        screen_lines  = FancyIrb::TerminalInfo.lines
        output_length = FancyIrb.real_lengths[:output]
        rocket_length = FancyIrb[:rocket_prompt].size
        stdout_lines  = FancyIrb.get_height

        # auto rocket mode
        if  screen_length > offset + rocket_length + output_length &&
            stdout_lines < screen_lines
          print FancyIrb::TerminalInfo::TPUT[:sc] +                # save current cursor position
                FancyIrb::TerminalInfo::TPUT[:cuu1]*stdout_lines + # move cursor upwards    to the original input line
                FancyIrb::TerminalInfo::TPUT[:cuf1]*offset +       # move cursor rightwards to the original input offset
                rocket +                                           # draw rocket prompt
                output +                                           # draw output
                FancyIrb::TerminalInfo::TPUT[:rc]                  # return to normal cursor position
          return
        end
      end
      # normal output mode
      FancyIrb.skip_next_rocket = false
      puts no_rocket + output
    end

    # colorize prompt & input
    alias prompt_non_fancy prompt
    def prompt(*args, &block)
      print Paint::NOTHING
      prompt = prompt_non_fancy(*args, &block)

      # this is kinda hacky... but that's irb °_°
      indents = @scanner.indent*2
      FancyIrb.continue = true if args[0] == IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_C]
      indents += 2 if FancyIrb.continue
      FancyIrb.real_lengths[:input_prompt] = prompt.size + indents

      colorized_prompt = FancyIrb.colorize prompt, FancyIrb[:colorize, :input_prompt]
      if input_color = FancyIrb[:colorize, :input]
        colorized_prompt + Paint.color(*Array(input_color)) # NOTE: No reset, relies on next one
      else
        colorized_prompt
      end
    end

    # track height and capture irb errors (part 2)
    alias signal_status_non_fancy signal_status
    def signal_status(name, *args, &block)
      FancyIrb.continue = false
      FancyIrb.reset_height
      signal_status_non_fancy(name, *args, &block)
    ensure
      if name == :IN_EVAL
        if FancyIrb.capture_irb_errors
          errors = FancyIrb.capture_irb_errors.string

          $stdout = FancyIrb.original_stdout
          FancyIrb.capture_irb_errors = nil
          FancyIrb.original_stdout    = nil

          unless errors.empty?
            warn FancyIrb.colorize(errors.chomp, FancyIrb[:colorize, :irb_errors])
          end
        end
      end#if
    end#def
  end#class

  class Context
    alias evaluate_non_fancy evaluate

    # capture irb errors (part 1)
    def evaluate(*args)
      FancyIrb.stdout_colorful = true
      evaluate_non_fancy(*args)
      FancyIrb.stdout_colorful = false
    rescue Exception => err
      FancyIrb.stdout_colorful    = false
      FancyIrb.capture_irb_errors = StringIO.new
      FancyIrb.original_stdout, $stdout = $stdout, FancyIrb.capture_irb_errors
      raise err
    end
  end
end

require_relative 'core_ext'
require_relative 'stream_ext'
require_relative 'clean_up'
