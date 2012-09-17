# -*- coding: utf-8 -*-

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

		# [:iterations, :iterations=, :elastic_iterations, :elastic_iterations=, :damping, :damping=, :gravity, :gravity=, :add_collision_func, :add_collision_handler, :on_collision, :remove_collision_func, :remove_collision_handler, :remove_collision, :set_default_collision_func, :set_default_collision_handler, :on_default_collision, :add_post_step_callback, :on_post_step, :add_shape, :add_static_shape, :add_body, :add_constraint, :remove_shape, :remove_static_shape, :remove_body, :remove_constraint, :resize_static_hash, :resize_active_hash, :rehash_static, :rehash_shape, :point_query, :point_query_first, :shape_point_query, :segment_query, :segment_query_first, :bb_query, :shape_query, :step, :object, :object=, :sleep_time_threshold=, :sleep_time_threshold, :idle_speed_threshold=, :idle_speed_threshold, :sleep_time=, :sleep_time, :idle_speed=, :idle_speed, :activate_shapes_touching_shape, :activate_touching, :add_object, :add_objects, :remove_object, :remove_objects, :psych_to_yaml, :to_yaml_properties, :to_yaml, :to_json, :require_all, :require_rel, :nil?, :===, :=~, :!~, :eql?, :hash, :<=>, :class, :singleton_class, :clone, :dup, :initialize_dup, :initialize_clone, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :frozen?, :to_s, :inspect, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :respond_to_missing?, :extend, :display, :method, :public_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :r, :psych_y, :==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__]
	    self._setupSpace()
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
		def _setupSpace
			@space.gravity = CP::Vec2.new(0, 10)
			# @space.damping = 0.9
		end
end
