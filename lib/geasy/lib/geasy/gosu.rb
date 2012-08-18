
require 'gl'
require 'RMagick'

module Gosu
	class Window
		def screenshot (file)
			gl {
				@data = glReadPixels( 0, 0, self.width(), self.height(), GL_RGB, GL_UNSIGNED_SHORT)
			}
			screenbuffer = Magick::Image.new(self.width(), self.height());
			screenbuffer.import_pixels(0, 0, self.width(), self.height(), "RGB", @data, Magick::ShortPixel).flip!
			screenbuffer.write(file);
			@data = nil
		end
	end
end