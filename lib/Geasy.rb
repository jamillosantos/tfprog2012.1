#--
# Author: Jamillo Santos
#++

GEASY_ROOT = File.dirname(File.expand_path(__FILE__))+File::SEPARATOR+'geasy'+File::SEPARATOR+'lib'
ROOT ||= File.dirname(File.expand_path($0))

require 'rubygems' unless RUBY_VERSION =~ /1\.9/
require 'gosu'
require 'chingu'
require 'json'
require File.join(GEASY_ROOT,"geasy") # Thanks to http://github.com/tarcieri/require_all !

# Seems like we need to include chingu/helpers first for BasicGameObject
# and GameObject to get the correct class_inheritable_accssor
require_all "#{GEASY_ROOT}/geasy/traits"
require_all "#{GEASY_ROOT}/geasy"

module Geasy
end
