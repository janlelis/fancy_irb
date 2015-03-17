module IRB
  class Irb
    def output_value
      output = FancyIrb.get_output_from_irb_context(@context)

      if FancyIrb[:rocket_mode] && !FancyIrb.skip_next_rocket
        offset = FancyIrb.get_offset_from_irb_scanner(@scanner)
        cols_to_show   = FancyIrb.get_cols_to_show_from_offset(offset)
        lines_to_show  = FancyIrb.get_height

        if  FancyIrb::TerminalInfo.lines > lines_to_show &&
            FancyIrb::TerminalInfo.cols  > cols_to_show
          print \
            Paint::NOTHING +
            FancyIrb::TerminalInfo::TPUT[:sc] +                    # save current cursor position
            FancyIrb::TerminalInfo::TPUT[:cuu1] * lines_to_show +  # move cursor upwards    to the original input line
            FancyIrb::TerminalInfo::TPUT[:cuf1] * offset +         # move cursor rightwards to the original input offset
            FancyIrb.colorize(FancyIrb[:rocket_prompt], FancyIrb[:colorize, :rocket_prompt]) + # draw rocket prompt
            output +                                               # draw output
            FancyIrb::TerminalInfo::TPUT[:rc]                      # return to normal cursor position
          return
        end
      end
      FancyIrb.skip_next_rocket = false
      puts \
        Paint::NOTHING +
        FancyIrb.colorize(FancyIrb[:result_prompt], FancyIrb[:colorize, :result_prompt]) +
        output
    end

    # colorize prompt & input
    alias prompt_non_fancy prompt
    def prompt(*args, &block)
      prompt = prompt_non_fancy(*args, &block)

      FancyIrb.track_indent! if args[0] == IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_C]
      FancyIrb.set_input_prompt_size(prompt, @scanner)

      colorized_prompt =
        Paint::NOTHING + FancyIrb.colorize(prompt, FancyIrb[:colorize, :input_prompt])

      FancyIrb.append_input_color(colorized_prompt)
    end

    # reset line and capture IRB errors (part 2)
    alias signal_status_non_fancy signal_status
    def signal_status(name, *args, &block)
      FancyIrb.reset_line!
      signal_status_non_fancy(name, *args, &block)
    ensure
      if name == :IN_EVAL
        FancyIrb.present_and_clear_captured_error!
      end
    end
  end

  class Context
    alias evaluate_non_fancy evaluate

    # capture IRB errors (part 1)
    def evaluate(*args)
      evaluate_non_fancy(*args)
    rescue Exception
      FancyIrb.register_error_capturer!
      raise
    end
  end
end
