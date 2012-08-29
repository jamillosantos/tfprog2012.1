
require 'chingu'
require 'chipmunk'

module Geasy
	class CPObject < Chingu::GameObject
		attr_reader :body, :shapes, :space

		def initialize(options)
			super(options)

			@space = options[:space]

			@setupOptions = options
			self._setupConfig
			self._setupBody
			self._setupShapes
			self._addToSpace
			@setupOptions = nil
		end

		protected
			def _initBody
				if (body = @setupOptions[:body]).nil?
					nil
				elsif (! (body.is_a? CP::Body))
					body = CP::Body.new(body[:weight] || Geasy::INFINITY, body[:moment] || Geasy::INFINITY)
					body.p.x = self.x
					body.p.y = self.y
				end
				body
			end

			def _setupBody
				@body = self._initBody
			end

			def _initShapes
				result = []
				unless (shapes = @setupOptions[:shapes]).nil?
					if shapes.is_a? Array
						shapes.each do |shape|
							tmp = CP::Shape::fromObject(@body, shape)
							tmp.collision_type = shape[:collisionType] || @setupOptions[:collisionType] || nil
							result << tmp
						end
					else
						result << CP::Shape::fromObject(@body, shapes)
						result[0].collision_type = shapes[:collisionType] || @setupOptions[:collisionType] || nil
					end
				end
				result
			end

			def _setupShapes
				@shapes = self._initShapes()
			end

			def _setupConfig
			end

			def _addToSpace
				puts '#######################################'
				@space.add_body(@body)
				if @setupOptions[:static]
					@shapes.each do |shape|
						@space.add_static_shape(shape)
					end
				else
					@shapes.each do |shape|
						@space.add_shape(shape)
					end
				end
			end

		public
			def space
				@space
			end

			def body
				@body
			end

			def shapes
				@shapes
			end

			def update
				self.x = @body.p.x
				self.y = @body.p.y
				super
			end
	end
end