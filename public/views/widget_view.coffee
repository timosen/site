class WidgetView extends Backbone.View

  initialize: ->
    @_grabOptions()

  template: _.template """
  <div class="epages-shop-header">
  <div class="epages-shop-search-form"></div>
  <div class="epages-shop-cart"></div>
  </div>
  <div class="epages-shop-navigation">
  <div class="epages-shop-sort"></div>
  <div class="epages-shop-category-list"></div>
  </div>
  <div class="epages-shop-product-list" data-i18n='loading'></div>
  <div class="epages-shop-taxes"></div>
  <div class="epages-shop-pagination"></div>

"""


  render: ->
    @$el.html @template()
    @_initRegions()
    App.i18n(this)
    this

  _grabOptions: ->
    @showCategoryList = _.contains [true], @$el.data("category-list")
    @showSearchForm   = _.contains [undefined, true], @$el.data("search-form")
    @showSort         = _.contains [undefined, true], @$el.data("sort")
    @resultsPerPage   = @$el.data("products-per-page") || 12
    @staticCategoryId = @$el.data("category-id")
    @productIds       = @$el.data("product-ids")?.split(/, */)
    @singleProduct    = @$el.data("product-details")

  _initRegions: ->
    @regions =
      productList:  @$(".epages-shop-product-list")
      categoryList: @$(".epages-shop-category-list")
      searchForm:   @$(".epages-shop-search-form")
      sort:         @$(".epages-shop-sort")
      pagination:   @$(".epages-shop-pagination")
      taxes:        @$(".epages-shop-taxes")
      cart:         @_findCart()

  _findCart: ->
    external_cart = $(":not(.epages-shop-widget) > .epages-shop-cart").first()
    internal_cart = @$(".epages-shop-cart")
    if external_cart.length > 0 then external_cart else internal_cart
