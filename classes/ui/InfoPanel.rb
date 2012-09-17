
module MadBirds
	module UI
		class InfoPanel < Geasy::UI::Panel
			def initialize(options = {})
				options[:align] = :bottom
				options[:backgroundColor] = Gosu::black
				options[:height] = 40
				options[:x] = 0
				options[:visible] = true
				super(options)
			end
		end
	end
end
