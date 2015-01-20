$(document).ready( ->
  require(
    ['search_bar', 'autocompletion', 'query_control', 'dropdown', 'map', 'asyncImg'],
    (SearchBar, Autocompletion, QueryControl, Dropdown, Map, asyncImg) ->
      bar = new SearchBar()

      $('.search-input').each( ->
        new Autocompletion($(this))
        new QueryControl($(this))
      )

      new Map($('#map')).render()

      new Dropdown(
        $('.btn-download'),
        $(".download-type-dropdown[data-download-type='general']")
      )

      asyncImg()
  )

  require(
    ['downloads_general', 'downloads_project', 'downloads_search'],
    (DownloadsGeneral, DownloadsProject, DownloadsSearch) ->
      $downloadBtns = [
        $(".download-type-dropdown[data-download-type='general'] a")
        $(".download-type-dropdown[data-download-type='search'] a")
        $(".download-type-dropdown[data-download-type='project'] a")
      ]

      return false if $downloadBtns.length == 0

      $downloadBtns.forEach( ($btn) ->
        $btn.on('click', (e) ->
          # skip standard links
          return unless $(@).data('type')

          button = $(@)
          e.preventDefault()

          list = button.parents('ul')

          DOWNLOADERS =
            'general': DownloadsGeneral
            'project': DownloadsProject
            'search': DownloadsSearch

          downloader = new DOWNLOADERS[list.data('download-type')](
            button.data('type'),
            {itemId: list.data('item-id')}
          )

          downloader.start()
        )
      )
  )

  $('.explore .search-input').focus()
)
