module MadBirds
	module Maps
		module Elements
			class Wood < BaseElement
				def initialize(options)
					puts options.deep_merge({
						:body => {
							:moment=>10000
						},
						:shapes=>{
							:type => :rect,
							:friction=>1
						}
					}).inspect
					super(options.merge({
						:body => {
							:moment=>10000
						},
						:shapes=>{
							:type => :rect,
							:friction=>1
						}
					}))
				end
			end
			
			class Wood2x2 < Wood
				def initialize(options)
					super(options.merge({
						:image => $imageManager.ids(:WOOD_BLOCK_2X2).image,
						:shapes => {
							:width => 35,
							:height => 35
						}
					}))
				end
			end
		end
	end
end