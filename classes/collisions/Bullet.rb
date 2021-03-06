
module MadBirds
	module Collisions
		class Bullet
			def begin(a, b, arbiter)
				if (b.object.is_a? MadBirds::Base::Bullet) # Bullets não afetam bullets
					false
				else
					a.object.explode(arbiter.points.first.point) if arbiter.first_contact? # Se for o primeiro contato, banda o objeto explodir
					true
				end
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
