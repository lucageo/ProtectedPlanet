$(document).ready( ->
  require(['factsheet_handler'], (FactsheetHandler) ->
    new FactsheetHandler($('.factsheet'))
  )

  require(['show_hide'], (ShowHide) ->
    quota = 6

    new ShowHide($('.js-show-hide'), quota)
  )

  require(['map', 'fullscreen'], (Map, Fullscreen) ->
    new Fullscreen($('.js-fullscreen-button'))

    #create maps !!the order of the maps matters!!
    mapSite = new Map($('#map-site'))
    mapSite.render()

    mapConnections = new Map($('#map-connections'))
    mapConnections.render()

    #pull out fullscreen buttons
    $mapConnectionsFullscreenButton = $('.js-fullscreen-button-connections')
    $mapSiteFullscreenButton = $('.js-fullscreen-button-site')

    #add click event that will re-render the map correctly when the fullscreen button is clicked
    $mapConnectionsFullscreenButton.on('click', ->
      mapConnections.resizeMap()
    )

    $mapSiteFullscreenButton.on('click', ->
      mapSite.resizeMap()
    )
  )

  require(['tabs', 'map_key'], (Tabs, MapKey) ->

    new Tabs($('.js-tabs-map'), ($tab, $tabContainer = null) ->

      #update the geometry when the tab is changed
      if($tab != null)
        window.ProtectedPlanet.Map.object.updateBounds($tab.data("network-id"))
        window.ProtectedPlanet.Map.object.updateMap($tab.data("wdpa-ids"))
        MapKey.resetKey($tab)

      #add event listeners to items in the map key
      if($tabContainer != null)

        $tabContents = $tabContainer.find('.js-tab-content')

        $.each($tabContents, (i, val) ->
          $tabContent = $(val)

          MapKey.initialize($tabContent)
        )
    )

    new Tabs($('.js-tabs-network'))
  )

  #require(['overlap'], (Overlap) ->
  #  new Overlap($('.pa-card'))
  #)
)
