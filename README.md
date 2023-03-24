# Birdel - microframework for rails
The new coding way to server<->client speaking and assets management
## 🛣️ Rona
This module proces JSON request and send inputs to actor method. Inside actor method you can write your custom code and response some output values. If request has required_component field - Rona module will authomatically render that component by passing outputs values to this component.

### Rona usage example

```js
  // Js request from any Birdel actor or Stimulus controller
  const req = {
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
  }
  window.Birdel.send(req);

  //Response example
  // {
  //   "ok": true,
  //   "message": "Order processed successfully",
  //   "data": {
  //     "actor": "ui__sunny_squirrel_actor",
  //     "method": "get_article",
  //     "outputs": {
  //       "articleId": 69
  //     },
  //     "html": "<html from required_component>",
  //   },
  //   "callback": {
  //     "component":   "home--articles-component",
  //     "actor":       "articles-component-actor",
  //     "method":      "renderArticle",
  //     "resource_id": false
  //   }
  // }
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

## Other examples
```ruby
# precomponents.json example

[
  "ui/birdel/fantasy",
  "ui/birdel/layout"
]

# components.json example
[
  "ui/bentries/home_component/home_component",
  "ui/mix/mini_product_component/mini_product_component"
]

# Entry pages structure
app/
├─ assets/
│  ├─ stylesheets/
│  │  ├─ bentries/
│  │  │  ├─ some_page/
│  │  │  │  ├─ index.css
│  │  │  │  ├─ components.css
│  │  │  │  ├─ precomponents.css.json
│  │  │  │  └─ components.css.json
│  │  │  ├─ otherpage/
│  │  │  │  ├─ index.css
│  │  │  │  ├─ components.css
│  │  │  │  ├─ precomponents.css
│  │  │  │  ├─ precomponents.css.json
│  │  │  │  └─ components.css.json
...
├─ javascript/
│  ├─ bentries/
│  │  ├─ some_page/
│  │  │  ├─ index.js
│  │  │  ├─ components.js
│  │  │  └─ components.js.json

# Actors structure
app/
├─ bactors/
├─── angry_cat_actor/
├───── angry_cat_actor.rb

# Component structure
app/
├─ components/
│  ├─ top_bar_component/
│  │  ├─ top_bar_component.rb
│  │  ├─ top_bar_component.js
│  │  ├─ top_bar_component.css
│  │  ├─ top_bar_component_controller.js
│  │  └─ top_bar_component_actor.js
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