require 'birdel'

module Birdel
  class CLI
    def self.start(args)
      method_name = args[0]
      method_param = args[1]
      if method_name == "synth"
        Birdel::Synth.roll
      elsif method_name == "gcom"
        Birdel::Com.roll(method_param)
      elsif method_name == "gent"
        Birdel::Map.roll(method_param)
      else
        puts "Wrong param".red
      end
    end
  end
end