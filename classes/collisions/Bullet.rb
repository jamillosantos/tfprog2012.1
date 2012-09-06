
module MadBirds
	module Collisions
		class Bullet
			def begin(a, b, arbiter)
				a.object.explode if arbiter.first_contact?
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
