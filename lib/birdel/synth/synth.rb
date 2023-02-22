require "json"
require 'pathname'
require 'colored'

root_path = Pathname.new("#{Dir.pwd}")
app_folder_path = Pathname.new("#{Dir.pwd}/app")

components_folder_path = Pathname.new("#{app_folder_path.to_s}/components")
js_folder_path = Pathname.new("#{app_folder_path.to_s}/javascript")
stylesheets_folder_path = Pathname.new("#{app_folder_path.to_s}/assets/stylesheets")

js_application_file_path = Pathname.new("#{js_folder_path.to_s}/ui/application.js")

css_entries = [
  "#{stylesheets_folder_path.to_s}/ui/entries/home",
  "#{stylesheets_folder_path.to_s}/ui/entries/lizard",
  "#{stylesheets_folder_path.to_s}/ui/entries/swallow",
]
js_entries = [
  "#{js_folder_path.to_s}/ui/entries/home",
  "#{js_folder_path.to_s}/ui/entries/lizard",
  "#{js_folder_path.to_s}/ui/entries/swallow",
]
css_entries_error = false
js_entries_error = false
css_entries.each do |entry_folder|
  entry_folder_path = Pathname.new(entry_folder)
  entry_folder_index_path = Pathname.new("#{entry_folder}/components.css")
  puts "(css) Building #{entry_folder_index_path.relative_path_from(app_folder_path)}".green
  entry_folder_components_path = Pathname.new("#{entry_folder}/components.json")
  File.truncate(entry_folder_index_path, 0)
  file = File.open(entry_folder_index_path, "w")
  
  #precomponents
  puts "-> (css) Precomponents...".yellow
  precomponents = JSON.parse(File.read("#{entry_folder}/precomponents.json"))
  precomponents.each do |precomponent_path_string|
    file_path = Pathname.new("#{stylesheets_folder_path.to_s}/#{precomponent_path_string}.css")
    if file_path.exist?
      puts "+ #{precomponent_path_string.split("/").last}.css"
      file.puts "@import url(\"#{file_path.relative_path_from(entry_folder_path).to_s}\");"
    else
      css_entries_error = true
      puts "File not found: #{file_path}".red
    end
  end

  file.puts ""

  #components
  puts "-> (css) Components...".yellow
  components = JSON.parse(File.read(entry_folder_components_path))
  components.each do |component_path_string|
    full_component_path = Pathname.new("#{components_folder_path.to_s}/#{component_path_string}.css")
    if full_component_path.exist?
      file_name = component_path_string.split("/").last
      puts "+ #{file_name}.css"
      file.puts "@import url(\"#{full_component_path.relative_path_from(entry_folder_path).to_s}\");"
    else
      css_entries_error = true
      puts "Component not found: #{component_path_string}".red
    end
  end
end
if css_entries_error
  puts "(css-error) Building failed.".red
  exit
end 
puts "(css-success) Building finished.".green
puts ""

js_entries.each do |entry|
  index_path = Pathname.new("#{entry}/components.js")
  entry_folder_path = Pathname.new(entry)
  puts "(js) Building #{index_path.relative_path_from(app_folder_path)}".green
  puts "-> (js) Components...".yellow
  File.truncate(index_path, 0)
  component_controllers = JSON.parse(File.read("#{entry}/components.json"))
  file = File.open(index_path, "w")
  js_application_file_name = js_application_file_path.basename.to_s.split(".").first
  file.puts "import { #{js_application_file_name} } from \"#{js_application_file_path.relative_path_from(entry_folder_path).to_s.gsub(js_application_file_path.extname, "")}\";"
  file.puts ""
  component_controllers.each do |component_path|
    path_parts = component_path.split("/")
    component_name = path_parts.pop
    controller_from_components = "#{component_path}/#{component_name}_controller"
    component_controller_path = Pathname.new("#{components_folder_path.to_s}/#{controller_from_components}.js")
    if component_controller_path.exist?
      component_path_dashed = component_path.tr("_", "-").gsub("/", "--")
      camelized_component_name = component_name.split("_").map(&:capitalize).join
      controller_backpath = component_controller_path.relative_path_from(entry_folder_path)
      controller_backpath_without_ext = controller_backpath.to_s.gsub(controller_backpath.extname, "")
      file.puts "import #{camelized_component_name} from \"#{controller_backpath_without_ext}\";"
      file.puts "application.register(\"#{component_path_dashed}\", #{camelized_component_name});"
      file.puts ""
      puts "+ #{component_path_dashed}"
    else
      js_entries_error = true
      puts "Stimulus controller not found: #{component_path}".red
    end
  end
end
if js_entries_error
  puts "(js-error) Building failed.".red
  exit
end
puts "(js-success) Building finished.".green
