toggleFilterChild = (event) ->
  event.preventDefault()

  $target = $(event.target)
  $target.toggleClass('active')

  $childList = $target.parent().find('ul')
  $childList.stop().slideToggle()

setupFiltersConcertina = ->
  $filtersList = $('.home-map-filters > ul')
  $filtersListItems = $filtersList.find('> li')

  $filtersListItems.find('ul').stop()
  $filtersListItems.on('click', '> a', toggleFilterChild)

ready = ->
  new ProtectedPlanet.Map($('#map')).render()
  new ProtectedPlanet.Dropdown($('.btn-map-download'), $('.download-type-dropdown'))

  setupFiltersConcertina()

$(document).ready(ready)
$(document).on('page:load', ready)
