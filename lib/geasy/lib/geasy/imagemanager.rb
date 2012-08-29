module Geasy
	# Classe ajudante que facilita na manipulação de imagens.
	# Author: J. Santos
	class ImageManager
		attr_reader :ids

		def [](value)
			if (@sprites[value] == nil) && ((tmp = @cache[value]) != nil)
				fromFile(value, @cache[value])
			end
			@sprites[value]
		end

		def ids(key)
			@ids[key]
		end

		def initialize()
			@sprites = {}
			@ids = {}
			@cache = {}
		end

		# Remove todas as imagens salvas.
		def clear
			@sprites = {}
			@ids = {}
			@cache = {}
			self
		end

		# Coloca a configuração em cache para quando for utilizada fazer,
		# automaticamente, o carregamento.
		def cache(options)
			options.each do |name, file|
				@cache[name] = file
			end
			self
		end

		def fromFile(id, file)
			json = JSON::parse(File.read(file), :symbolize_names => true)
			@sprites[id] = result = SpriteGroup.new
			for i in (0...json[:spriteCount]) do
				o = json[('sprite_'+i.to_s).to_sym]
				id = o[:id].to_sym;
				if result.sprites[id].nil?
					result.sprites[id] = Sprite.new({:image=>File.join('gfx',json[:image]), :x=>o[:x], :y=>o[:y], :width=>o[:width], :height=>o[:height], :pivotx=>o[:pivotx], :pivoty=>o[:pivoty]})
					@ids[id] = result.sprites[id]
				end
			end
			true
		end
	end
end