module FancyIrb
  module IrbExtCommon
    def output_value(_omit = false)
      FancyIrb.output_value(@context, @scanner)
    end

    def signal_status(name, *args, &block)
      FancyIrb.reset_line!
      super(name, *args, &block)
    ensure
      if name == :IN_EVAL
        FancyIrb.present_and_clear_captured_error!
      end
    end
  end

  module IrbExtPrompt
    private def format_prompt(format, ltype, indent, line_no)
      FancyIrb.handle_prompt(
        super(format, ltype, indent, line_no),
        IRB.conf[:AUTO_INDENT] ? indent * 2 : 0
        # IRB.conf[:AUTO_INDENT] && IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_C] == format
      )
    end
  end

  module IrbExtPromptLegacy
    def prompt(format, ltype, indent, line_no)
      FancyIrb.handle_prompt(
        super(format, ltype, indent, line_no),
        IRB.conf[:AUTO_INDENT] ? indent * 2 : 0
        # IRB.conf[:AUTO_INDENT] && IRB.conf[:PROMPT][IRB.conf[:PROMPT_MODE]][:PROMPT_C] == format
      )
    end
  end

  module ContextExt
    def evaluate(*args, **kwargs)
      super(*args, **kwargs)
    rescue Exception
      FancyIrb.register_error_capturer!
      raise
    end
  end
end

module IRB
  class Irb
    prepend FancyIrb::IrbExtCommon

    if IRB::VERSION < "1.8.2"
      prepend FancyIrb::IrbExtPromptLegacy
    else
      prepend FancyIrb::IrbExtPrompt
    end
  end

  class Context
    prepend FancyIrb::ContextExt
  end
end
