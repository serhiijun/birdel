# Birdel - make rails great again 🐦

Use actors as never before

## 🛣️ Router - resolve request/respond

Processing birdel.js actors requests based on request specifications. And response based on response specification

## 🔄 Cif - Chain of Responsibility pattern

Each actor should be sure, that previews actor successfully finished his job.

## 🧩 Components generator

Birdel can generate actors (or components same to ViewComponent generator)

```
# Nested namespace example
$ birdel act Ui::AngryCatActor
```
```
app/
├─ bactors/
├─── ui/
├───── angry_cat_actor/
├─────── angry_cat_actor.rb
├─────── angry_cat_actor_specification.rb

```
$ birdel com Ui::TopBarComponent
```
```
app/
├─ components/
│  ├─ ui/
│  │  ├─ top_bar_component/
│  │  │  ├─ top_bar_component.rb
│  │  │  ├─ top_bar_component.js
│  │  │  ├─ top_bar_component.css
│  │  │  ├─ top_bar_component_controller.js
│  │  │  └─ top_bar_component_actor.js
```

## 📈 Synth - Building indexes

You should store your entries same to this:
```
app/
├─ assets/
│  ├─ stylesheets/
│  │  ├─ bentries/
│  │  │  ├─ home/
│  │  │  │  ├─ index.css
│  │  │  │  ├─ components.css
│  │  │  │  ├─ precomponents.json
│  │  │  │  └─ components.json
│  │  │  ├─ some_page/
│  │  │  │  ├─ index.css
│  │  │  │  ├─ components.css
│  │  │  │  ├─ precomponents.json
│  │  │  │  └─ components.json

# Feel free to put bentries/ folder inside some nested folder in stylesheets/
```

```
# Resynchoronize entries
$ birdel synth
```

```
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
```

## 📜 Request/Response specifications

```ruby
#"actorDirect" and "actorThrough" - still an idea for some field
#Request
{
  "actor": "angry_cat_actor",
  "method": "process_order",
  "required_component": "ui--bars--top-bar-component",
  "inputs": {
    "customer": "John Doe",
    "items": [
      { "name": "Milk", "price": 1.5 },
      { "name": "Bread", "price": 2.5 }
    ]
  },
  "callback": {
    "actor": "angry_swallow_actor",
    "method": "process_bla",
    "inputs": {
      "customer": "John Doe",
      "items": [
        { "name": "Milk", "price": 1.5 },
        { "name": "Bread", "price": 2.5 }
      ]
    }
  }
}

#Response
{
  "ok": true,
  "message": "Order processed successfully",
  "data": {
    "actor": "angry_cat_actor",
    "method": "process_order",
    "outputs": {
      "order_id": 1234,
      "total_amount": 4.0,
    },
    "html": "<div></div>",
  }
}
```

## Actor

```ruby
class AngryCatActor::AngryCatActor < Birdel::BaseActor
  def initialize()
  end
  def process_order

  end
end
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