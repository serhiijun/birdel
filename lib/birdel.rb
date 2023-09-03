# frozen_string_literal: true
require "json"
require 'pathname'
require 'colored'
require 'active_support/inflector'

require_relative "birdel/version"
require_relative "birdel/base/base_actor"
require_relative "birdel/rona/rona_actor"
require_relative "birdel/synth/synth_actor"
require_relative "birdel/com/com_actor"
require_relative "birdel/map/map_actor"
require_relative "birdel/component/component_actor"
module Birdel
  class Error < StandardError; end
  class << self
  end
end
