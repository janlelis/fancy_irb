module FancyIrb
  module SizeDetector
    extend self

    def width_of(data)
      data = Paint.unpaint data.to_s
      if FancyIrb[:east_asian_width]
        data.display_size
      else
        data.size
      end
    end

    def height_of(data, width)
      lines      = data.count("\n")
      long_lines = data.split("\n").inject(0){ |sum, line|
        sum + (width_of(line) / width)
      }
      lines + long_lines
    end
  end
end
