class @ProtectedAreaMap
  constructor: (elementId) ->
    @el = $("##{elementId}")
    @map = L.map(elementId, {scrollWheelZoom: false})

    L.tileLayer('http://api.tiles.mapbox.com/v3/unepwcmc.ijh17499/{z}/{x}/{y}.png').addTo(@map)
    L.tileLayer('http://carbon-tool.cartodb.com/tiles/wdpa_poly_feb2014_0/{z}/{x}/{y}.png').addTo(@map)

  fitToBounds: (bounds, withPadding) ->
    opts = {}
    if withPadding?
      padding = @calculatePadding()
      opts.paddingTopLeft = padding.topLeft
      opts.paddingBottomRight = padding.bottomRight

    @map.fitBounds(bounds, opts)

  setZoomControlPosition: (position) ->
    @map.zoomControl.setPosition(position)

  locate: ->
    @map.locate(setView: true)

  calculatePadding: ->
    mapSize = @map.getSize()
    paddingLeft = mapSize.x/5
    {topLeft: [paddingLeft, 50], bottomRight: [0, 50]}
