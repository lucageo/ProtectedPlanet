class AddBboxToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :bbox, :text
  end
end
