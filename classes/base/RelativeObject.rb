
module MadBirds
	module Base
		class RelativeObject < Object

			attr_accessor :relTo, :relX, :relY

			def initialize(options = {})
				self.relTo = options[:relTo]
				self.relX = options[:relX] || 0
				self.relY = options[:relY] || 0

				super(options)
			end

			public
				def relX
					@relX
				end

				def relX=(value)
					@relX = value
				end

				def relY
					@relY
				end

				def relY=(value)
					@relY = value
				end

				def relTo
					@relTo
				end

				def relTo=(value)
					@relTo = value
				end

				def update
					super

					self.x = @relTo.x + @relX
					self.y = @relTo.y + @relY
				end

				def destroy
					self.relTo = nil
					super
				end
		end

		class RelativeText < Chingu::Text

			attr_accessor :relTo, :relX, :relY

			def initialize(text, options = {})
				self.relTo = options[:relTo]
				self.relX = options[:relX] || 0
				self.relY = options[:relY] || 0

				super(options)
			end

			public
				def relX
					@relX
				end

				def relX=(value)
					@relX = value
				end

				def relY
					@relY
				end

				def relY=(value)
					@relY = value
				end

				def relTo
					@relTo
				end
	
				def relTo=(value)
					@relTo = value
				end

				def update
					super

					self.x = @relTo.x + @relX
					self.y = @relTo.y + @relY
				end

				def destroy
					self.relTo = nil
					super
				end
		end
	end
end