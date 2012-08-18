module Geasy
	class Config
		def initialize()
			@cache = {}
		end

		def [](name)
			if (!@cache[sym = name.gsub('/', File::SEPARATOR).to_sym])
				@cache[sym] = JSON::load File.read('config' + File::SEPARATOR + name + '.json')
			end
			@cache[sym]
		end
	end
end