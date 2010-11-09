module IRB
  class Irb
    def colorize(string, color)
      if defined?(Wirble) && color && color_string = Wirble::Colorize::Color.escape( color.to_sym )
        color_string + string.to_s + Wirble::Colorize::Color.escape( :nothing )
      else
      #  if defined? Wirble
      #    Wirble::Colorize::Color.escape( :nothing ) + string.to_s
      #  else
          string.to_s
      #  end
      end
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

      # try to output in rocket mode (depending on rocket_mode setting)
      if FancyIrb[:rocket_mode]
        # get lengths
        last_input               = @scanner.instance_variable_get( :@line )
        last_line_without_prompt = last_input.split("\n").last
        offset = last_line_without_prompt.size + FancyIrb.real_lengths[:input_prompt] + 1
        screen_length = `tput cols`.to_i
        output_length = FancyIrb.real_lengths[:output]
        rocket_length = FancyIrb[:rocket_prompt].size
        stdout_lines  = FancyIrb.get_height

        # auto rocket mode
        if FancyIrb[:rocket_mode] && screen_length > offset + rocket_length + output_length
          print `tput sc` +                # save current cursor position
                `tput cuu1`*stdout_lines + # move cursor upwards    to the original input line
                `tput cuf1`*offset +       # move cursor rightwards to the original input offset
                rocket +                   # draw rocket prompt
                output +                   # draw output
                `tput rc`                  # return to normal cursor position
          return
        end
      end
      # normal output mode
      puts no_rocket + output
    end

    # colorize prompt & input
    alias prompt_non_fancy prompt
    def prompt(*args, &block)
      prompt = prompt_non_fancy(*args, &block)
      FancyIrb.real_lengths[:input_prompt] = prompt.size
      colorized_prompt = colorize prompt, FancyIrb[:colorize, :input_prompt]
      #if input_color = FancyIrb[:colorize, :input]
      #  colorized_prompt + Wirble::Colorize::Color.escape( input_color )  # NOTE: No reset, relies on next one TODO
      #else
        colorized_prompt
      #end
    end

    # track height and capture irb errors (part 2)
    alias signal_status_non_fancy signal_status
    def signal_status(name, *args, &block)
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

# TODO  
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
