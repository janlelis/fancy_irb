if FancyIrb[:east_asian_width]
  require 'unicode/display_size'
else
  class String
    alias display_size size
  end
end

module IRB
  class Irb
    if FancyIrb.win?
      TPUT = {
        :sc   => "\e[s",
        :rc   => "\e[u",
        :cuu1 => "\e[1A",
        :cuf1 => "\e[1C",
      }
    else
      TPUT = {
        :sc   => `tput sc`,
        :rc   => `tput rc`,
        :cuu1 => `tput cuu1`,
        :cuf1 => `tput cuf1`,
      }
    end

    def colorize(string, color)
      Paint[string, *Array(color)]
    end

    def output_value
      # prepare prompts
      rocket    = colorize FancyIrb[:rocket_prompt], FancyIrb[:colorize, :rocket_prompt]
      no_rocket = colorize FancyIrb[:result_prompt], FancyIrb[:colorize, :result_prompt]
      
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
        screen_length = FancyIrb.current_length
        screen_lines  = FancyIrb.current_lines
        output_length = FancyIrb.real_lengths[:output]
        rocket_length = FancyIrb[:rocket_prompt].size
        stdout_lines  = FancyIrb.get_height

        # auto rocket mode
        if  screen_length > offset + rocket_length + output_length &&
            stdout_lines < screen_lines
          print TPUT[:sc] +                # save current cursor position
                TPUT[:cuu1]*stdout_lines + # move cursor upwards    to the original input line
                TPUT[:cuf1]*offset +       # move cursor rightwards to the original input offset
                rocket +                   # draw rocket prompt
                output +                   # draw output
                TPUT[:rc]                  # return to normal cursor position
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
     
      colorized_prompt = colorize prompt, FancyIrb[:colorize, :input_prompt]
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
            warn colorize( errors.chomp, FancyIrb[:colorize, :irb_errors] )
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

# hook into streams to count lines and colorize
class << $stdout
  alias write_non_fancy write
  def write(data)
    FancyIrb.track_height data
    FancyIrb.write_stream $stdout, data, FancyIrb[:colorize, :stdout]
  end
end

class << $stderr
  alias write_non_fancy write
  def write(data)
    FancyIrb.track_height data
    FancyIrb.write_stream $stderr, data, FancyIrb[:colorize, :stderr]
  rescue Exception # catch fancy_irb errors
    write_non_fancy data
  end
end

# deactivate rocket for common system commands
%w[system spawn].each{ |m|
  Object.send(:define_method, m.to_sym, &lambda{ |*args, &block|
    FancyIrb.skip_next_rocket = true
    super(*args, &block)
  })
}

# patch some input methods to track height
alias gets_non_fancy gets
def gets(*args)
  res = gets_non_fancy *args
  FancyIrb.track_height res
  res
end

# TODO testing and improving, e.g. getc does not contain "\n"
class << $stdin
  stdin_hooks = %w[binread read gets getc getbyte readbyte readchar readline readlines readpartial sysread]
  # TODO: each_byte, each_char, each_codepoint, each

  stdin_hooks.each{ |m|
    msym   = m.to_sym
    malias = (m+'_non_fancy').to_sym

    if $stdin.respond_to? msym
      alias_method malias, msym
      define_method msym do |*args|
        res = send malias, *args
        FancyIrb.track_height res
        res
      end
    end
  }
end

END{ print "\e[0m" } # reset colors when exiting

# J-_-L
