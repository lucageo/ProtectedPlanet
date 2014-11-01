window.ProtectedPlanet ||= {}

class ProtectedPlanet.Map
  L.mapbox.accessToken = 'pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiRXg1RERWRSJ9.taTsSWwtAfFX_HMVGo2Cug'

  constructor: (@$mapContainer) ->

  render: ->
    if @$mapContainer.length == 0 or ProtectedPlanet.Map.mapInitiated
      return false

    config = @$mapContainer.data()

    map = @createMap(@$mapContainer.attr('id'))
    ProtectedPlanet.Map.mapInitiated = true

    ProtectedPlanet.Maps.BaseLayer.render(map)
    ProtectedPlanet.Maps.Bounds.setToBounds(map, config)
    ProtectedPlanet.Maps.ProtectedAreaOverlay.render(map, config)
    ProtectedPlanet.Maps.Search.showSearchResults(map, config.url)
    if config.animate and !config.url?
      ProtectedPlanet.Maps.Animation.startAnimation(map)

  createMap: (id) ->
    L.mapbox.map(
      id,
      'unepwcmc.ijh17499',
      {zoomControl: false, attributionControl: false}
    ).addControl(L.control.zoom(position: 'topright'))
