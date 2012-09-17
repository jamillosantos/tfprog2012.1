
module MadBirds
	module Maps
		module Elements
			class BaseElement < Geasy::CPObject
				include MadBirds::Base::LifeObject
			
				def initialize(options)
					self.initializeLifeObject(options)
					options[:collisionType] = :Elements
					super(options)
				end
			end
		end
	end
end
