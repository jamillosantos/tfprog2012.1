
# Este módulo concentra as classes de Tween.
module Teasy

	# Classe ajudante que faz os cálculos de transição.
	class Tween

		def initialize(from, to, total, easing)
			self.from = from
			self.to = to
			self.easing = easing
			self.total = total
			@started = false
		end

		# Setters and Getters

		attr_accessor :from, :to, :easing, :total

		def from
			@from
		end

		def from=(value)
			@from = value
		end

		def to
			@to
		end

		def to=(value)
			@to = value
		end

		def easing
			@easing
		end

		def easing=(value)
			@easing = value
		end

		## Methods

		def elapsedTime
			(Time.now - @startTime)
		end

		def elapsedSeconds
			elapsedTime.to_f
		end

		def start
			@startTime = Time.now.to_f
			@started = true
			self
		end

		def update
			j = -1
			c = elapsedSeconds
			if c > @total
				c = @total
			end
			@easing.ease(c, @from, @to, @total)
		end

		def reverseUpdate
			j = -1
			c = elapsedSeconds
			if c > @total
				c = @total
			end
			@easing.ease(c, @to, @from, @total)
		end

		def raw(c)
			j = -1
			if c > @total
				c = @total
			end
			@easing.ease(c, @from, @to, @total)
		end

		def reverseRaw(c)
			j = -1
			if c > @total
				c = @total
			end
			@easing.ease(c, @to, @from, @total)
		end

		def finish
		end

		def stop
			@startTime = nil
			@started = false
			self
		end

		def started?
			@started
		end
	end

	class ProcTween < Tween
		def start(block)
			@block = block
		end

		def update
			@block.call result = super()
			result
		end

		def finish
			unless @blockFinish.nil?
				@blockFinish.call()
			end
		end
	end

	class TweenArray < Tween

		def easing=(value)
			if (!value.instance_of? Array)
				value = [value]
			end
			@easing = value
		end

		def update
			j = -1
			c = elapsedSeconds
			if c > @total
				c = @total
			end
			@from.map { |i|
				j += 1
				@easing[j % @easing.size].ease(c, i, @to[j], @total)
			}
		end

		def reverseUpdate
			j = -1
			c = elapsedSeconds
			if c > @total
				c = @total
			end
			@from.map { |i|
				j += 1
				@easing[j % @easing.size].ease(c, @to[j], i, @total)
			}
		end

		def raw(c)
			j = -1
			if c > @total
				c = @total
			end
			@from.map { |i|
				j += 1
				@easing[j].ease(c, i, @to[j], @total)
			}
		end

		def reverseRaw(c)
			j = -1
			if c > @total
				c = @total
			end
			@from.map { |i|
				j += 1
				@easing[j].ease(c, @to[j], i, @total)
			}
		end
	end

	module Easing

		module None

			def self.ease(t, st, ch, d)
				ch * t / d + st
			end
		end

		module Sine

			module In

				def self.ease(t, st, ch, d)
					-ch * Math.cos(t / d * (Math::PI / 2)) + ch + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					ch * Math.sin(t / d * (Math::PI / 2)) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					-ch / 2 * (Math.cos(Math::PI * t / d) - 1) + st
				end
			end
		end

		module Circ
			module In

				def self.ease(t, st, ch, d)
					-ch * (Math.sqrt(1 - (t/d) * t/d) - 1) + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					t = t/d - 1
					ch * Math.sqrt(1 - t * t) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if (t /= d/2.0) < 1
						return -ch / 2 * (Math.sqrt(1 - t*t) - 1) + st
					else
						return ch / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + st
					end
				end
			end
		end

		module Bounce

			module In

				def self.ease(t, st, ch, d)
					ch - self.out(d-t, 0, ch, d) + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					if (t /= d) < (1/2.75)
						ch * (7.5625 * t * t) + st
					elsif t < (2 / 2.75)
						ch * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + st
					elsif t < (2.5 / 2.75)
						ch * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + st
					else
						ch * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + st
					end
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if t < d/2.0
						Teasy::Easing::Bounce::In.ease(t*2.0, 0, ch, d) * 0.5 + st
					else
						Teasy::Easing::Bounce::Out.ease(t*2.0 - d, 0, ch, d) * 0.5 + ch * 0.5 + st
					end
				end
			end
		end

		module Back
			module In

				def self.ease(t, st, ch, d, s=1.70158)
					ch * (t/=d) * t * ((s+1) * t - s) + st
				end
			end

			module Out

				def self.ease(t, st, ch, d, s=1.70158)
					ch * ((t=t/d-1) * t * ((s+1) * t + s) + 1) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d, s=1.70158)
					if (t /= d/2.0) < 1
						ch / 2.0 * (t * t * (((s *= (1.525)) + 1) * t - s)) + st
					else
						ch / 2.0 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + st
					end
				end
			end
		end

		module Cubic

			module In

				def self.ease(t, st, ch, d)
					ch * (t /= d) * t * t + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					ch * ((t = t / d.to_f - 1) * t * t + 1) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if (t /= d / 2.0) < 1
						ch / 2.0 * t * t * t + st
					else
						ch / 2.0 * ((t -= 2) * t * t + 2) + st
					end
				end
			end
		end

		module Expo
			module In

				def self.ease(t, st, ch, d)
					if t == 0
						st
					else
						ch * (2 ** (10 * (t / d.to_f - 1))) + st
					end
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					if t == d
						st + ch
					else
						ch * (-(2 ** (-10 * t / d.to_f)) + 1) + st
					end
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if t == 0
						st
					elsif t == d
						st + ch
					elsif (t /= d / 2.0) < 1
						ch / 2.0 * (2 ** (10 * (t - 1))) + st
					else
						ch / 2.0 * (-(2 ** (-10 * (t -= 1))) + 2) + st
					end
				end
			end
		end

		module Quad

			module In

				def self.ease(t, st, ch, d)
					ch * (t /= d.to_f) * t + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					-ch * (t /= d.to_f) * (t - 2) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if (t /= d / 2.0) < 1
						ch / 2.0 * t * t + st
					else
						-ch / 2.0 * ((t -= 1) * (t - 2) - 1) + st
					end
				end
			end
		end

		module Quart

			module In

				def self.ease(t, st, ch, d)
					ch * (t /= d.to_f) * t * t * t + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					-ch * ((t = t / d.to_f - 1) * t * t * t - 1) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if (t /= d / 2.0) < 1
						ch / 2.0 * t * t * t * t + st
					else
						-ch / 2.0 * ((t -= 2) * t * t * t - 2) + st
					end
				end
			end
		end

		module Quint

			module In

				def self.ease(t, st, ch, d)
					ch * (t /= d.to_f) * t * t * t * t + st
				end
			end

			module Out

				def self.ease(t, st, ch, d)
					ch * ((t = t / d.to_f - 1) * t * t *t * t + 1) + st
				end
			end

			module InOut

				def self.ease(t, st, ch, d)
					if (t /= d / 2.0) < 1
						ch / 2.0 * t * t *t * t * t + st
					else
						ch / 2.0 * ((t -= 2) * t * t * t * t + 2) + st
					end
				end
			end
		end

		module Elastic

			module In

				def self.ease(t, st, ch, d, a = 5, p = 0)
					s = 0
					if t == 0
						return st
					elsif (t /= d.to_f) >= 1
						return st + ch
					end
					p = d * 0.3 if p == 0
					if (a == 0) || (a < ch.abs)
						a = ch
						s = p / 4.0
					else
						s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
					end
					-(a * (2 ** (10 * (t -= 1))) * Math.sin( (t * d - s) * (2 * Math::PI) / p)) + st
				end
			end

			module Out

				def self.ease(t, st, ch, d, a = 0.1, p = 0)
					s = 0
					if t == 0
						return st
					elsif (t /= d.to_f) >= 1
						return st + ch
					end
					p = d * 0.3 if p == 0
					if (a == 0) || (a < ch.abs)
						a = ch
						s = p / 4.0
					else
						s = p / (2 * Math::PI) * Math.asin(ch / a.to_f)
					end
					a * (2 ** (-10 * t)) * Math.sin((t * d - s) * (2 * Math::PI) / p.to_f) + ch + st
				end
			end
		end

		module Strong
			module In
				def self.ease(t, b, c, d)
					c*(t/=d)*t*t*t*t + b;
				end
			end

			module Out
				def self.ease(t, b, c, d)
					c*((t=t/d-1)*t*t*t*t + 1) + b;
				end
			end

			module InOut
				def self.ease(t, b, c, d)
					if ((t/=d*0.5) < 1) 
						c*0.5*t*t*t*t*t + b
					else
						c*0.5*((t-=2)*t*t*t*t + 2) + b;
					end
				end
			end
		end
	end

	class TweenManager

		def initialize
		end

		def create(from, to, total, easing)
			@tweens << Tween.new(self, from, to, total, easing)
		end

		def remove(tween)
			@tweens.remove tween
		end
	end
end
