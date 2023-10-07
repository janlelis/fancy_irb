module IRB
  class Irb
    def output_value
      FancyIrb.output_value(@context, @scanner)
    end

    alias prompt_non_fancy prompt
    def prompt(prompt_arg, ltype, indent, line_no)
      FancyIrb.handle_prompt(
        prompt_non_fancy(prompt_arg, ltype, indent, line_no),
        IRB.conf[:AUTO_INDENT] ? indent * 2 : 0
        # IRB.conf[:AUTO_INDENT] && IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_C] == prompt_arg
      )
    end

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

    def evaluate(*args, **kwargs)
      evaluate_non_fancy(*args, **kwargs)
    rescue Exception
      FancyIrb.register_error_capturer!
      raise
    end
  end
end
