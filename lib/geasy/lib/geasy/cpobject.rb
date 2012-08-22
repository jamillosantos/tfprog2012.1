
require 'chingu'
require 'chipmunk'

module Geasy
	class CPObject < Chingu::GameObject
		attr_reader :body, :shapes

		def initialize(options)
			super(options)

			@setupOptions = options
			self._setupBody
			self._setupShapes
			@setupOptions = nil
		end

		protected
			def _initBody
			end

			def _setupBody
				@body = self._initBody
			end

			def _initShapes
				[]
			end

			def _setupShapes
				@shapes = self._initShapes()
			end

		public
			def body
				@body
			end

			def shapes
				@shapes
			end
	end
end