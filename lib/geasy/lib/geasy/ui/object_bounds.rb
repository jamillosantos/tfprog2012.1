
module Geasy
	module UI
		module ObjectBounds
			attr_accessor :x, :y, :width, :height

			protected
				def initializeBounds(options)
					puts 'ObjectBounds::initializeBounds', options.inspect
					self.x = options[:x] || 0
					self.y = options[:y] || 0
					self.width = options[:width] || 100
					self.height = options[:height] || 100
				end

			public
				def x
					@x
				end

				def x=(value)
					@x = value
				end

				def y
					@y
				end

				def y=(value)
					@y = value
				end

				def width
					@width
				end

				def width=(value)
					@width = value
				end

				def height
					@height
				end

				def height=(value)
					puts 'ObjectBounds::height=', value.inspect
					@height = value
				end
		end
	end
end
