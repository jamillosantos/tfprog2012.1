module Geasy
	class SpriteGroup
		attr_accessor :sprites
		def initialize()
			@sprites = {}
		end

		def sprites()
			@sprites
		end
	end

	class Sprite
		attr_accessor :image, :x, :y, :width, :height, :pivotx, :pivoty
		def initialize(options)
			@image = Gosu::Image.new($window, options['image'], true, options['x'], options['y'], options['width'], options['height'])
			@x = options['x']
			@y = options['y']
			@width = options['width']
			@height = options['height']
			@pivotx = options['pivotx']
			@pivoty = options['pivoty']
		end

		def image
			@image
		end

		def x
			@x
		end

		def y
			@y
		end

		def width
			@width
		end

		def height
			@height
		end

		def pivotx
			@pivotx
		end

		def pivoty
			@pivoty
		end
	end
end