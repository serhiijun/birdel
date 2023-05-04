# Routing Overlay Network Actor
module Birdel
  module Rona
    def actorThrough(data)
      actor_name         = data.fetch("actor")
      inputs             = data.fetch("inputs")
      callback           = data.fetch("callback")
      required_component = data.fetch("required_component")
      method             = data.fetch("method")

      actor_string = actor_name.split("__").map{|e| e.camelize}.join("::")
      res_name = actor_string << "::#{actor_string.split("::")[-1]}"
      actor = res_name.constantize.new()
      method_res = actor.public_send(method, inputs, self.current_user)
      res = {
        "ok": method_res[:ok],
        "message": method_res[:message],
        "data": {
          "actor": actor_name,
          "method": method,
          "outputs": method_res[:outputs]
        }
      }
      if required_component
        component_name = required_component.split('--').map{|i| i.gsub("-", "_").camelize}.join('::') + '::' + required_component.split('--').last.gsub("-", "_").camelize
        component = component_name.constantize.new(inputs: method_res[:outputs])
        res[:data][:html] = ApplicationController.render(component, layout: false)
      end
      if callback
        res[:callback] = callback
        res[:callback][:resourceId] = method_res[:resource_id] if method_res[:resource_id]
        ActionCable.server.broadcast(self.first_stream, res)
      end
    end

    def actorDirect(data)
      inputs             = data.fetch("inputs")
      callback           = data.fetch("callback")
      required_component = data.fetch("required_component")
      component_name     = required_component.split('--').map{|i| i.gsub("-", "_").camelize}.join('::') + '::' + required_component.split('--').last.gsub("-", "_").camelize
      component          = component_name.constantize.new(inputs: inputs)
      res = {
        "ok": true,
        "message": "Actor Direct",
        "data": {
          "outputs": inputs,
          "html": ApplicationController.render(component, layout: false)
        }
      }
      res[:callback]              = callback
      res[:callback][:resourceId] = callback[:resource_id]
      ActionCable.server.broadcast(self.first_stream, res)
    end
  end
end