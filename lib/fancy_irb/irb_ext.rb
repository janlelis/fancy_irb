module IRB
  class Irb
    def output_value
      output = FancyIrb.get_output_from_irb_context(@context)
      FancyIrb.show_output(output, @scanner)
    end

    # colorize prompt & input
    alias prompt_non_fancy prompt
    def prompt(*args, &block)
      prompt = prompt_non_fancy(*args, &block)

      FancyIrb.track_indent! if args[0] == IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_C]
      FancyIrb.set_input_prompt_size(prompt, @scanner)

      FancyIrb.append_input_color(FancyIrb.colorize(prompt, :input_prompt))
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
