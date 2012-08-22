module Geasy
	class Config
		def initialize()
			@cache = {}
		end

		def [](name)
			if (!@cache[sym = name.gsub('/', File::SEPARATOR).to_sym])
				@cache[sym] = JSON::parse File.read(File.join(ROOT, 'config', name + '.json')), :symbolize_names => true
			end
			@cache[sym]
		end
	end
end