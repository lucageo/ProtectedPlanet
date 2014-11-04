class AssetsController < ApplicationController

  def tiles
    image = AssetGenerator.protected_area_tile(protected_area, asset_params)
    send_data image, type: 'image/png', disposition: 'inline'
  end

  private

  def asset_params
    params.slice(:size)
  end

  def protected_area
    @protected_area ||= ProtectedArea.find(params[:id])
  end
end
