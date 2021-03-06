# -*- coding: utf-8 -*-

module Kernel
	def r (path)
		require File.dirname(__FILE__) + File::SEPARATOR + 'classes' + File::SEPARATOR + path.gsub('/', File::SEPARATOR)
	end
end


$: << File.dirname(__FILE__) + File::SEPARATOR + 'lib'
GFX = File.dirname(__FILE__) + File::SEPARATOR + 'gfx'

require 'gosu'
require 'chingu'
require 'deep_merge'
require 'geasy'

require 'socket'

require File.join(File.dirname(__FILE__), 'lib', 'require_all', 'lib', 'require_all.rb')

require_all 'classes'

$config = Geasy::Config.new

$window = MainWindow.new
$window.show

=begin
	require('geasy')
	
	color = Gosu::Color.new(Geasy::Color.fadeTo(0xffffffff, 0.5))
	puts '----'
	puts color.alpha.to_s 16
	puts '----'
	puts Geasy::Color.fadeTo(0xffffffCA, 0.5).to_s 16
	puts '----'
=end

#require('Teasy')
#puts Teasy::Easing::Strong::Out.ease(0.5, 2, 1, 1);
