module FancyIrb
  module SizeDetector
    def self.width_of(data)
      if FancyIrb[:east_asian_width]
        data.display_size
      else
        data.size
      end
    end

    def self.height_of(data, width)
      data       = Paint.unpaint(data.to_s)
      lines      = data.count("\n")
      long_lines = data.split("\n").inject(0){ |sum, line|
        sum + (width_of(line) / width)
      }
      lines + long_lines
    end
  end
end
