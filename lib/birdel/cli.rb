require 'thor'

module Birdel
  class CLI < Thor
    desc "gcom NAME", "Generate a new component"
    def gcom(name)
      Birdel::Com.roll(name)
    end

    desc "synth", "Syncronize components assets"
    def synth
      Birdel::Synth.roll(name)
    end
  end
end