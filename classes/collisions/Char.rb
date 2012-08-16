
module MadBirds
	module Collisions
		class Char
			def begin(a, b, arbiter)
				puts 'MadBirds::Collisions::Char::begin()'
				a.object.groundKick
				true
			end
		
			def pre_solve(a, b)
				true
			end
		
			def post_solve(arbiter)
				true
			end
		
			def separate()
				true
			end
		end
	end
end
