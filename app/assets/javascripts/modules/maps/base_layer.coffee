define('base_layer', [], ->
  class BaseLayer
    @render: (map, opts={}) ->
      terrain = L.mapbox.tileLayer('unepwcmc.l8gj1ihl')
      satellite = L.mapbox.tileLayer('unepwcmc.lac5fjl1')
      marine = L.mapbox.styleLayer('mapbox://styles/unepwcmc/cj63iq5m04i142rl0481raoxj')

      # add Terrain/Satellite button
      if !opts.hideControl
        L.control.layers({
          "<span data-layer='Terrain'>Terrain</span>": terrain,
          "<span data-layer='Satellite'>Satellite</span>": satellite
        }, null, {
          position: opts.controlPosition || 'topleft'
        }).addTo(map)

        layers = {
          "<span data-layer='Terrain'>Terrain</span>": "Terrain",
          "<span data-layer='Satellite'>Satellite</span>": "Satellite"
        }

        map.on('baselayerchange', (e) ->
          for layerName, layerId of layers
            layerControl = $("span[data-layer='#{layerId}']")

            if layerName == e.name
              layerControl.addClass("is-selected")
            else
              layerControl.removeClass("is-selected")
        )

        terrainControl = $("span[data-layer='Terrain']")
        terrainControl.addClass("is-selected")
      
      # add marine style
      if opts.style == 'marine'
        marine.addTo(map)

  return BaseLayer
)
