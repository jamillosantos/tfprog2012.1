
require 'bindata'

module MadBirds
	module Network
		class PacketData < BinData::Record
		end

		class PacketObjectContent < BinData::Record
		end

		class PacketObjectContentGameObject < BinData::Record
		end

		class PacketCPBody < BinData::Record
			floatle :m
			floatle :angle
		end

		class PacketCPBodySync < BinData::Record
			uint32le :x
			uint32le :y
			floatle :angle
		end

		class PacketObject < PacketData
			uint32le :objId
			PacketObjectContent :data
		end

		class Packet < BinData::Record
			int8le :command
			PacketData :data
		end
	end
end
