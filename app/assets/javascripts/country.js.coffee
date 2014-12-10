require(['application', 'jquery', 'modules/annular_sector'], (app, $, annularSector)->
  $vizContainer = $('#protected-coverage-viz')
  return false if $vizContainer.length == 0

  $vizContainer.find('.viz').each (idx, el) ->
    value = $(el).attr('data-value')
    return if typeof +value isnt 'number' or +value is isNaN
    data = [
      {
        value: value
        color: $(el).attr('data-colour')
      }
      {
        value: 100 - value
        color: '#d2d2db'
        is_background: true
      }
    ]

    annularSector data, el, 160, 160
)
