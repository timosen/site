class WidgetView extends Backbone.View

  initialize: ->
    @_grabOptions()

  template: _.template """
    <div class="epages-shop-cart"></div>
    <div class="epages-shop-navigation">
      <div class="epages-shop-category-list"></div>
      <div class="epages-shop-sort"></div>
      <div class="epages-shop-search-form"></div>
    </div>

    <div class="epages-shop-product-list">Loading ...</div>

    <div class="epages-shop-pagination"></div>

    <style type="text/css">
      .epages-shop-navigation {
        margin-bottom: 50px;
      }
      .epages-shop-navigation {
        clear: both;
      }
      .epages-shop-navigation > div {
        float: left;
        margin-right: 1em;
      }
      .epages-shop-product-list {
        clear: both;
      }
      .epages-shop-pagination {
        clear: both;
        text-align: center;
      }
      .epages-shop-cart {
        float: right;
        margin-right: 0;
      }
      .epages-cart-button {
        background: url(#{App.rootUrl}/images/cart.png) left center no-repeat;
        padding-left: 25px;
        padding-right: 2px;
        cursor: pointer;
        border: 0;
        outline: none;
      }
    </style>
  """

  render: ->
    @$el.html @template()
    @_initRegions()
    this

  _grabOptions: ->
    @showCategoryList = _.contains [true], @$el.data("category-list")
    @showSearchForm   = _.contains [undefined, true], @$el.data("search-form")
    @showSort         = _.contains [undefined, true], @$el.data("sort")
    @resultsPerPage   = @$el.data("products-per-page") || 12
    @staticCategoryId = @$el.data("category-id")
    @productIds       = @$el.data("product-ids")?.split(/, */)

  _initRegions: ->
    @regions =
      productList:  @$(".epages-shop-product-list")
      categoryList: @$(".epages-shop-category-list")
      searchForm:   @$(".epages-shop-search-form")
      sort:         @$(".epages-shop-sort")
      pagination:   @$(".epages-shop-pagination")
      cart:         @_findCart()

  _findCart: ->
    external_cart = $(":not(.epages-shop-widget) > .epages-shop-cart").first()
    internal_cart = @$(".epages-shop-cart")
    if external_cart.length > 0 then external_cart else internal_cart
