class CartLineItemView extends Backbone.View

  tagName: "tr"

  events:
    "change .epages-cart-overlay-line-item-quantity": "changeQuantity"
    "click .epages-cart-overlay-line-item-remove": "removeLineItem"

  template: _.template """
    <td class="epages-cart-overlay-image">
      <img src="<%= itemImage %>">
    </td>
    <td class="epages-cart-overlay-name"><%= name %></td>
    <td class="epages-cart-overlay-price"><span class="epages-cart-overlay-subhead-narrow" data-i18n='unit-price'></span><%= singleItemPrice %></td>
    <td class="epages-cart-overlay-quantity">
      <span class="epages-cart-overlay-subhead-narrow" data-i18n='quantity'></span><input type="number" class="epages-cart-overlay-line-item-quantity" value="<%= quantity %>">
      <%= unit %>
    </td>
    <td class="epages-cart-overlay-total"><span class="epages-cart-overlay-subhead-narrow" data-i18n='total-price'></span><%= lineItemPrice %></td>
    <td class="epages-cart-overlay-remove">
      <button class="epages-cart-overlay-line-item-remove"
              alt="Remove product">
      </button> <span>Remove product</span>
    </td>
  """

  render: ->
    @$el.html @template
      itemImage:       @model.get("variationImage") || @model.largeImage()
      name:            @model.name()
      quantity:        @model.quantity()
      unit:            @model.unit()
      singleItemPrice: @model.formattedPrice()
      lineItemPrice:   @model.get("lineItemPrice") || ''
   
    App.i18n(this)
    this
  
  changeQuantity: (event) ->
    quantity = parseInt(event.target.value)
    @model.set(quantity: quantity)


  removeLineItem: (event) ->
    event.preventDefault()
    event.target.disabled = true # disable button

    @model.collection.remove(@model)
