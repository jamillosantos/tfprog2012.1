# -*- coding: utf-8 -*-

require 'geasy'
require 'chingu'

# Chipmunk steps.
# @see http://beoran.github.com/chipmunk/#Space
CP_STEPS = 10

class Game < Chingu::GameState
	attr_accessor :space

	def initialize(options = {})
		super(options)

		@dt = (1.0/60)

		# Chipmunkspace initialization
		@space = CP::Space.new
	    self.setupSpace()
	end

	def space
		@space
	end

	def update
		CP_STEPS.times do
			@space.step(@dt)
		end
		super
	end

	protected
	def setupSpace
		@space.gravity = CP::Vec2.new(0, 10)
	end
end
