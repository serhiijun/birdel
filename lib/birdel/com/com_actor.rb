module Birdel
  module Com
    def self.roll
      app_path               = Pathname.new("#{Dir.pwd}")
      components_path        = app_path.join("app", "components")
      component_ns           = ARGV[0]
      component_ns_camelized = component_ns.split("::").map(&:camelize).join("::")
      component_name         = component_ns_camelized.split("::").last
      component_path         = component_ns.split("::").join("/")
      full_component_path    = components_path.join(component_path.underscore)

      variable_name = "css_class"
      css_class = component_ns_camelized.underscore.gsub('_', '-').gsub('/', '--')
      actor_name = "#{component_name}Actor"
      files = [
{
  name: "#{component_name.underscore}.rb",
  content: "
class #{component_ns_camelized}::#{component_name} < ViewComponent::Base
  include Birdel::Component
end
"
},
{ name: "#{component_name.underscore}.css", content: ".#{css_class}{}" },
{ name: "#{component_name.underscore}.js", content: "" },
{
  name: "#{component_name.underscore}_controller.js",
  content: "
import { #{actor_name} } from \"./#{component_name.underscore}_actor\";
import { Controller } from \"@hotwired/stimulus\";
export default class extends Controller {
  connect() {}
}
" },
{
  name: "#{component_name.underscore}_actor.js",
  content: "
import { ActorBase } from \"birdeljs\"
export class #{actor_name} extends ActorBase {
  constructor() {
    console.log(\"#{actor_name}!\");
  }
}
"},
{ name: "#{component_name.underscore}.html.erb", content: "<div class=\"<%= #{variable_name} %>\" data-controller=\"<%= #{variable_name} %>\">\n</div>" },
]

      files.each do |file|
        file_path = full_component_path.join(file[:name])
        if file_path.exist?
          puts "File already exists: #{file_path}".red
        else
          puts "Creating file: #{file_path}".yellow
          #create new file and folders if needed
          file_path.dirname.mkpath
          File.open(file_path, "w") do |f|
            f.puts file[:content]
          end
          if file_path.exist?
            puts "Done!".bold.green
          else
            puts "Failed".red
          end
        end
      end
    end
  end
end
