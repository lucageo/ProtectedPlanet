class @DownloadSelectionModal extends Modal
  DEFAULT_TYPES = ['csv', 'shapefile', 'kml']
  BASE_DOWNLOAD_PATH = '/downloads'

  @template: """
    <div id="download-modal" class="modal">
    <i class="fa fa-cloud-download fa-3x"></i>
      <h2>Select a file type to download</h2>
      <section>
        <div id="link-container"></div>
        <h2>or</h2>
        <a href="http://ec2-54-204-216-109.compute-1.amazonaws.com:6080/arcgis/rest/services/wdpa/wdpa/MapServer" class="btn btn-primary">use our ESRI web service <i class="fa fa-external-link"></i></a>
      </section>

      <a href="#" id="close-modal"><i class="fa fa-times fa-2x"></i></a>
    </div>
  """

  constructor: ($container) ->
    super($container)
    @addCloseFunctionality()

  buildLinksFor: (objectName, types) ->
    types ||= DEFAULT_TYPES
    linkContainer = @$el.find('#link-container')

    newLinks = types.map((type) ->
      typeLinkText = type.toUpperCase()
      typeLinkHref = "#{BASE_DOWNLOAD_PATH}/#{objectName}?type=#{type}"

      """
        <a target="_blank" class="btn btn-primary" href="#{typeLinkHref}">#{typeLinkText}</a>
      """
    )

    linkContainer.html(newLinks)