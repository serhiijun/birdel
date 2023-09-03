# Routing Overlay Network Actor
module Birdel
  module Rona
    def actorThrough(data)
      actor_name         = data.fetch("actor")
      inputs             = data.fetch("inputs")
      callback           = data.fetch("callback", false)
      required_component = data.fetch("required_component")
      method             = data.fetch("method")

      actor_string = actor_name.split("__").map{|e| e.camelize}.join("::")
      res_name     = actor_string << "::#{actor_string.split("::")[-1]}"
      actor        = if res_name.constantize.ancestors.include?(Birdel::BaseActor)
        res_name.constantize.new(current_user: self.current_user)
      else
        res_name.constantize.new
      end
      method_res   = if actor.respond_to?(:current_user)
        actor.public_send(method, inputs)
      else
        actor.public_send(method, inputs, self.current_user)
      end
      res = {
        "ok":        method_res[:ok],
        "message":   method_res[:message],
        "data": {
          "actor":   actor_name,
          "method":  method,
          "outputs": method_res[:outputs]
        }
      }
      if required_component
        component_name    = required_component.split('--').map{|i| i.gsub("-", "_").camelize}.join('::') + '::' + required_component.split('--').last.gsub("-", "_").camelize
        component         = component_name.constantize.new(inputs: method_res[:outputs])
        res[:data][:html] = ApplicationController.render(component, layout: false)
      end
      if callback
        res[:callback] = callback
        # first - check if Actor method returned specific resource_id
        # otherwise - set resource_id from callback if it exists or set false
        if method_res[:resource_id].present?
          res[:callback][:resourceId] = method_res[:resource_id]
        else
          res[:callback][:resourceId] = callback["resourceId"].present? ? callback["resourceId"] : false
        end
        ActionCable.server.broadcast(self.first_stream, res)
      end
    end
  end
end