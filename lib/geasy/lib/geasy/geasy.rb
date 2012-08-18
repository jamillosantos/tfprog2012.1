
# É uma camada construída sobre o Gosu com certas facilidades.
# 
# Author:: J. Santos
# Class:: 2012.1.101.404
module Geasy

	INFINITY = 1.0/0

	# Faz transformações de cores.
	class Color
		# Retorna a cor, númerica, resultante do gradiente entre as duas passadas.
		# @todo Testar esta função pois não está funcionando
		def self.gradient(fromColor, toColor, index = 0.5)
			(((self.a(fromColor) + (((self.a(toColor) - self.a(fromColor))*index).to_i))%256) << 24) + (((self.r(fromColor) + (((self.r(toColor) - self.r(fromColor))*index).to_i))%256) << 16) + (((self.g(fromColor) + (((self.g(toColor) - self.g(fromColor))*index).to_i))%256) << 8) + (((self.b(fromColor) + (((self.b(toColor) - self.b(fromColor))*index).to_i))%256))
		end

		# Altera o canal alpha da cor
		def self.fadeTo(color, alpha)
			(color & (((255*alpha).to_i << 24) + 0xffffff))
		end
		
		########################################################################

		def initialize(color)
			@color = color
		end

		# Retorna o canal alpha da cor
		def a
			Color.a(@color)
		end

		# Retorna o canal alpha da cor informada.
		def self.a(color)
			(color & 0xff000000) >> 24
		end

		# Retorna o canal red da cor
		def r
			Color.r(@color)
		end

		# Retorna o canal red da cor informada
		def self.r(color)
			(color & 0xff0000) >> 16
		end

		# Retorna o canal green da cor
		def g
			Color.g(@color)
		end

		# Retorna o canal green da cor informada
		def self.g(color)
			(color & 0xff00) >> 8
		end

		# Retorna o canal blue da cor
		def b
			Color.b(@color)
		end

		# Retorna o canal blue da cor informada
		def self.b(color)
			(color & 0xff)
		end
	end
end
