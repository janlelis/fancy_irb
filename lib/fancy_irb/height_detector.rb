module FancyIrb
  module HeightDetector
    def self.run(data, cols_available)
      data       = Paint.unpaint(data.to_s)
      lines      = data.count("\n")
      long_lines = data.split("\n").inject(0){ |sum, line|
        sum + (line.display_size / cols_available)
      }
      lines + long_lines
    end
  end
end
