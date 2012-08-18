module Geasy
	# Classe ajudante que facilita na manipulação de imagens.
	# Author: J. Santos
	class ImageManager
		def [](value)
			if (@sprites[value] == nil) && ((tmp = @cache[value]) != nil)
				fromFile(value, @cache[value])
			end
			@sprites[value]
		end

		def initialize()
			@sprites = {}
			@cache = {}
		end

		# Remove todas as imagens salvas.
		def clear
			@sprites = {}
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
			json = JSON::load File.read(file)
			@sprites[id] = result = SpriteGroup.new
			for i in (0...json['spriteCount']) do
				o = json['sprite_'+i.to_s]
				if result.sprites[o['id']].nil?
					result.sprites[o['id']] = Sprite.new({'image'=>'gfx'+File::SEPARATOR+json['image'], 'x'=>o['x'], 'y'=>o['y'], 'width'=>o['width'], 'height'=>o['height'], 'pivotx'=>o['pivotx'], 'pivoty'=>o['pivoty']})
				end
			end
			true
		end
	end
end