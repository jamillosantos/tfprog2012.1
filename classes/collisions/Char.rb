
module MadBirds
	module Collisions
		class Char
			def begin(a, b, arbiter)
				puts 'MadBirds::Collisions::Char::begin()'
				a.object.groundKick if arbiter.first_contact?
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
