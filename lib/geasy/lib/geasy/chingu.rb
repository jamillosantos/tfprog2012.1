module Chingu
	class GameObject
		attr_accessor :delete_when

		def destroy_when
			@destroy_when
		end

		def checkDestroy
			end
		end

		def update
			super
			self.checkDestroy
		end
	end
end