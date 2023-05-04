module Birdel
  module Component
    def css_class
      self.class.name.underscore.gsub('_', '-').gsub('/', '--').split('--')[0..-2].join('--')
    end
  end
end