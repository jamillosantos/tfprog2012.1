
module Geasy
	module UI
		class Panel < Chingu::GameObject
			include ObjectBounds

			def initialize(options)
				self.initializeBounds(options)

				self.backgroundColor = options[:backgroundColor] || Gosu::black
				super(options)
				self.align = options[:align] || :bottom
			end

			protected

				def drawBackground
					$window.draw_quad(@parent.viewport.x + self.x, @parent.viewport.y + self.y, @backgroundColor, @parent.viewport.x + self.x + self.width, @parent.viewport.y + self.y, @backgroundColor, @parent.viewport.x + self.x + self.width, @parent.viewport.y + self.y + self.height, @backgroundColor, @parent.viewport.x + self.x, @parent.viewport.y + self.y + self.height, @backgroundColor, 1000000)
				end
		
			public

				def align
					@align
				end
				
				def align=(value)
					@align = value
					case @align
					when :top
						self.y = 0
					when :right
						self.x = 0
					when :bottom
						self.y = $window.height - self.height
					when :left
						self.x = $window.width - self.width
					end
				end

				def backgroundColor
					@backgroundColor
				end

				def backgroundColor=(value)
					@backgroundColor = value
				end

				def draw
					super
					self.drawBackground
				end
		end
	end
end