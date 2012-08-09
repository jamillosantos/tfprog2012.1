#--
# Part of Chingu -- OpenGL accelerated 2D game framework for Ruby
# Copyright (C) 2009 ippa / ippa@rubylicio.us
#
# Written/Refactored by Jakub Hozak - jakub.hozak@gmail.com
#
#++

module Geasy
	module Traits
		module Sprite
			## include Chingu::Helpers::RotationCenter    # Adds easy and verbose modification of @center_x and @center_y
			module ClassMethods
				def initialize_trait(options = {})
					trait_options[:chipmunk] = options
				end
			end

			attr_accessor :x, :y, :angle, :factor_x, :factor_y, :center_x, :center_y, :zorder, :mode, :color
			attr_reader :factor, :center, :height, :width, :image
			attr_accessor :visible # kill this? force use of setter

			def setup_trait(object_options = {})
				@visible = true   unless options[:visible] == false
				self.image =  options[:image]  if options[:image]
				self.color =  options[:color] || ::Gosu::Color::WHITE.dup
				self.alpha =  options[:alpha]  if options[:alpha]
				self.mode =   options[:mode] || :default
				self.x =      options[:x] || 0
				self.y =      options[:y] || 0
				self.zorder = options[:zorder] || 100
				self.angle =  options[:angle] || 0

				self.factor = options[:factor] || options[:scale] || $window.factor || 1.0
				self.factor_x = options[:factor_x].to_f if options[:factor_x]
				self.factor_y = options[:factor_y].to_f if options[:factor_y]
				self.rotation_center = options[:rotation_center] || :center_center

				if self.image
					self.width  = options[:width]   if options[:width]
					self.height = options[:height]  if options[:height]
					self.size   = options[:size]    if options[:size]
				end

				super
			end

			#
			# Let's have some useful information in to_s()
			#
			def to_s
				"#{self.class.to_s} @ #{x.to_i} / #{y.to_i} " <<
				"(#{width.to_i} x #{height.to_i}) - " <<
				"ratio: #{sprintf("%.2f",width.to_f/height.to_f)} " <<
				"scale: #{sprintf("%.2f", factor_x)}/#{sprintf("%.2f", factor_y)} " <<
				"angle: #{angle.to_i} zorder: #{zorder} alpha: #{alpha}"
			end

			#
			# Get all settings from a game object in one array.
			# Complemented by the GameObject#attributes= setter.
			# Makes it easy to clone a objects x,y,angle etc.
			#
			def attributes
				[@x, @y, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode, @zorder]
			end

			def attributes=(attributes)
				self.x, self.y, self.angle, self.center_x, self.center_y, self.factor_x, self.factor_y, self.color, self.mode, self.zorder = *attributes
			end

			def draw
				@image.draw_rot(@x, @y, @zorder, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode)  if @image
			end
		end
	end
end
