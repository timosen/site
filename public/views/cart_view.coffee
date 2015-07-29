class CartView extends Backbone.View

  initialize: ->
    @listenTo @collection, "reset update", @render

  tagName: "button"

  className: "epages-cart-button"

  events:
    "click": "openCart"

  template: _.template """
    Basket (<%= count %>)
  """

  render: ->
    @$el.html @template(count: @collection.length)
    this

  openCart: (event) ->
    event.preventDefault()

    view = new CartDetailView(collection: @collection).render()
    App.modal.open(view)
