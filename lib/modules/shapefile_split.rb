require 'gdal-ruby/ogr'

class ShapefileSplit
  def split layer: layer, filename: filename, number_of_pieces: number_of_pieces
    @filename = filename
    @layer = layer
    @number_of_pieces = number_of_pieces

    limit = feature_count / number_of_pieces

    (0..number_of_pieces-1).collect do |piece_index|
      shapefile_name = "#{layer}_#{piece_index}"
      new_shapefile_path = File.join(File.dirname(@filename), "#{shapefile_name}.shp")
      offset = limit * piece_index

      ogr_shapefile = OgrShapefile.new @filename, new_shapefile_path
      ogr_shapefile.convert_with_query query(limit, offset)
    end
  end

  private

  def query limit, offset
    "SELECT * FROM #{@layer} LIMIT #{limit} OFFSET #{offset}"
  end

  def feature_count
    ogr_driver = Gdal::Ogr.open(@filename)
    layer = ogr_driver.get_layer(@layer)

    return layer.get_feature_count
  end
end
