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
        for p in response.lineItemContainer.productLineItems
          product = _(@models).chain().pluck('attributes').flatten().findWhere(productId: p.productId).value()
          product.lineItemPrice = p.lineItemPrice.formatted

        @subTotal = response.lineItemContainer.lineItemsSubTotal.formatted
        @deliveryPrice = response.lineItemContainer.shippingPrice.formatted
        @total = response.lineItemContainer.grandTotal.formatted
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


