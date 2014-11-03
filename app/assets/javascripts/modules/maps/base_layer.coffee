window.ProtectedPlanet ||= {}
window.ProtectedPlanet.Maps ||= {}

class ProtectedPlanet.Maps.BaseLayer
  @render: (map) ->
    terrain = L.mapbox.tileLayer('unepwcmc.ijh17499')
    satellite = L.mapbox.tileLayer('unepwcmc.k2p9jhk8')

    L.control.layers(
      "Terrain": terrain,
      "Satellite": satellite
    ).addTo(map)