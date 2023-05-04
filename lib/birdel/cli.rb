require 'thor'
require_relative "birdel/synth/synth_actor"
require_relative "birdel/com/com_actor"
require_relative "birdel/map/map_actor"
require_relative "birdel/component/component_actor"

module Birdel
  class CLI < Thor
    desc "gcom NAME", "Generate a new component"
    def gcom(name)
      Birdel::Com.roll(name)
    end

    desc "gcom NAME", "Generate a new component"
    def gent(name)
      Birdel::Map.roll(name)
    end

    desc "synth", "Syncronize components assets"
    def synth
      Birdel::Synth.roll(name)
    end
  end
end