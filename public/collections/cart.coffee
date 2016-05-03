class Cart extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId } = options

    @storage = new Storage("cart")
    @storage.on "update", @_loadFromStorage

    @getShippingUrl()

    @on "update:cartId", @_updateSubTotal
    @on "reset update change", @_dumpToStorage

  model: Product

  save: ->
    Backbone.sync("create", this, timeout: 10 * 1000)

  sync: ->
    @deliveryPrice = undefined # reset to avoid render previous delivery prices
    Backbone.sync("create", this, timeout: 10 * 1000)
      .done (response) =>
        @deliveryPrice = response.lineItemContainer.shippingPrice
        @trigger("update:cartId", response.cartId)

  url: ->
    "#{App.apiUrl}/shops/#{@shopId}/carts"

  shippingUrl: ->
    "#{App.apiUrl}/shops/#{@shopId}/categories"

  toJSON: ->
    lineItems = @map (model) -> model.toJSON()
    lineItems: lineItems

  getShippingUrl: ->
    $.getJSON @shippingUrl()
      .done (response) => @shippingUrl = response[0].sfUrl + "/Shipping"

  lineItemsTotal: ->
    shipping = if @deliveryPrice then @deliveryPrice.amount else 0
    sum = (sum, model) -> sum + model.totalPrice()
    "#{ @reduce(sum, shipping).toFixed(2) } €"

  lineItemsSubTotal: ->
    sum = (sum, model) -> sum + model.totalPrice()
    "#{ @reduce(sum, 0).toFixed(2) } €"

  loadFromStorage: ->
    data = @storage.get("cart")
    @reset(data) if data

  _loadFromStorage: (event) =>
    if event.key is @storage.key("cart")
      @loadFromStorage()

  _dumpToStorage: =>
    @storage.set "cart", @map (product) -> product.attributes

  _updateSubTotal: (cartId) =>
    @trigger "change" # manual trigger because the items didn't change


