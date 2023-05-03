# Birdel - microframework for rails
The new coding way to server<->client speaking and assets management
## 🛣️ Rona
This module proces JSON request and send inputs to actor method. Inside actor method you can write your custom code and response some output values. If request has required_component field - Rona module will authomatically render that component by passing outputs values to this component.

### Rona usage example

```js
  // Birdel.js request
  window.Birdel.send({
    "actor": "ui__sunny_squirrel_actor",
    "method": "get_article",
    "required_component": "home--article-component",
    "inputs": {
      "articleId": 69
    },
    "callback": {
      "component":   "home--articles-component",
      "actor":       "articles-component-actor",
      "method":      "renderArticle",
      "resource_id": false
    }
  });

  //Response example
  {
    "ok": true,
    "message": "Rendered article",
    "data": {
      "actor": "ui__sunny_squirrel_actor",
      "method": "get_article",
      "outputs": {
        "article": {id:...}
      },
      "html": "<div>My Article component html</div>",
    },
    "callback": {
      "component":   "home--articles-component",
      "actor":       "articles-component-actor",
      "method":      "renderArticle",
      "resource_id": false
    }
  }
```

```js
  // Birdel.js Direct request
  window.Birdel.sendDirect({
    "required_component": "home--confirm-modal-component",
    "inputs": {
      "confirmMessage": "Are you sure?"
    },
    "callback": {
      "component":   "home--modals-component",
      "actor":       "modals-component-actor",
      "method":      "appendModal",
      "resource_id": false
    }
  });

  //Response example
  {
    "ok": true,
    "message": "Actor Direct",
    "data": {
      "outputs": {
        "confirmMessage": "Are you sure?"
      },
      "html": "<div>My confirmation modal component html</div>",
    },
    "callback": {
      "component":   "home--articles-component",
      "actor":       "articles-component-actor",
      "method":      "renderArticle",
      "resource_id": false
    }
  }
```


```ruby
# Actor processor
class SunnySquirrelActor::SunnySquirrelActor
  def get_article(inputs, current_user)
    article_id = inputs.fetch("articleId")
    article = Article.find_by(id: cupboard_id)
    return {ok: false, message: "Article not found", outputs: {}} unless article
    return {ok: true, message: "Article", outputs: {article: article}}
  end
end
```

```ruby
  #Your main channel for current entry page
  class HomeChannel < ApplicationCable::Channel
    state_attr_accessor :first_stream
    include Birdel::Rona

    def subscribed
      self.first_stream = "#{params[:channel]}_#{params[:id]}"
      stream_from self.first_stream
    end
  end
```

## Blah Blah Blah

- [ ] Cif - Chain of Responsibility pattern
- [x] Components generator
- [ ] Actors generator
- [ ] Actors specifications
- [x] Synth - rewrite CSS ans JS indexes
- [x] Map - generate entry page

## 📝 Map

Entry pages indexes generator module

```bash
$ birdel map Ui::Bentries::Home
# + app/assets/stylesheets/ui/bentries/home/components.css.json
# + app/assets/stylesheets/ui/bentries/home/precomponents.css.json
# + app/assets/stylesheets/ui/bentries/home/components.css
# + app/assets/stylesheets/ui/bentries/home/precomponents.css
# + app/assets/stylesheets/ui/bentries/home/index.css

# + app/javascript/ui/bentries/home/components.js.json
# + app/javascript/ui/bentries/home/components.js
# + app/javascript/ui/bentries/home/index.js

# + app/viewslayouts/ui/bentries/home/index.html.erb
```

### Visualized files structure
```
# Css structure
app/
├─ assets/
│  ├─ stylesheets/
│  │  ├─ ui/
│  │  │  ├─ bentries/
│  │  │  │  ├─ some_page/
│  │  │  │  │  ├─ index.css
│  │  │  │  │  ├─ components.css
│  │  │  │  │  ├─ precomponents.css.json
│  │  │  │  │  └─ components.css.json

# Javascript structure
├─ javascript/
│  ├─ ui/
│  │  ├─ bentries/
│  │  │  ├─ some_page/
│  │  │  │  ├─ index.js
│  │  │  │  ├─ components.js
│  │  │  │  └─ components.js.json

# Actors structure
app/
├─ ui/
│  ├─ bactors/
│  │  ├─ angry_cat_actor/
│  │  │  └─ angry_cat_actor.rb

# Component structure random example
app/
├─ ui/
│  ├─ bentries/
│  │  ├─ home/
│  │  │  ├─ home_component/
│  │  │  │  ├─ home_component.rb
│  │  │  │  ├─ home_component.js
│  │  │  │  ├─ home_component.css
│  │  │  │  ├─ home_component_controller.js
│  │  │  │  └─ home_component_actor.js
│  ├─ mix/
│  │  ├─ home/
│  │  │  ├─ top_bar_component/
│  │  │  │  ├─ top_bar_component.rb
│  │  │  │  ├─ top_bar_component.js
│  │  │  │  ├─ top_bar_component.css
│  │  │  │  ├─ top_bar_component_controller.js
│  │  │  │  └─ top_bar_component_actor.js
```



```ruby
# app/assets/stylesheets/ui/home/precomponents.json

[
  "ui/birdel/dropdown",
  "ui/birdel/layout"
]

# app/assets/stylesheets/ui/home/components.css.json
[
  "ui/bentries/home/home_component/home_component",
  "ui/mix/home/mini_product_component/mini_product_component"
]

# app/views/layouts/ui/bentries/home/index.html.erb
...
  <%= stylesheet_link_tag "ui/bentries/home/index", "data-turbo-track": "reload" %>
  <%= javascript_include_tag "ui/bentries/home/index", "data-turbo-track": "reload", defer: true, type: "module" %>
...
```

## Actor Specification example

```ruby
class AngryCatActor::AngryCatActorSpecification
  def initialize(msg)
    parsed_msg = JSON.parse(msg)
    @msg = parsed_msg.transform_keys(&:to_sym)
  end

  def inputs
    [
      { name: "customer", type: "string" },
      { name: "items", type: "array" }
    ]
  end

  def outputs
    [
      { name: "order_id", type: "integer" },
      { name: "total_amount", type: "float" }
    ]
  end

  def methods
    [
      { name: "process_order", input: ["customer", "items"], output: ["order_id", "total_amount"] }
    ]
  end

  def msg_valid?
    @msg[:inputs]&.keys.to_set == inputs.map { |i| i[:name] }.to_set &&
    inputs.all? { |i| @msg[:inputs][i[:name]].is_a?(i[:type].camelize.constantize) }
  end
end
```