# Birdel - microframework for rails

Generate component
```bash
$ birdel gcom Ui::Bentries::Home::HomeComponent
```
Generate entry
```bash
$ birdel gent Home
```
Sync css and js
```bash
$ birdel synth
```
Send request
```js
window.Birdel.actor("ui__angry_cat_actor")
  .method("get_article")
  .required_component("ui--mix--article-component") // or false
  .inputs({
    articleId: 69
  })
  .callback({
    "component":   "ui--entries--home-component",
    "actor":       "home-component-actor",
    "method":      "showArticle",
    "resource_id": false //or ID of your actor
  })
  .send()
```

Full documentation is not ready and will be at https://digitalthing.io/docs/birdel, well, sorry😄
