# frozen_string_literal: true

require_relative "birdel/version"
require_relative "birdel/com/com"
require_relative "birdel/map/map"
require_relative "birdel/rona/rona"
require_relative "birdel/synth/synth"

module Birdel
  class Error < StandardError; end
  class << self
    def test1
      puts "Birdel is a gem for sending messages to your actors and getting view_components back!"
    end
  end
end
