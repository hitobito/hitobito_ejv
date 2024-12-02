class RemoveRegionalverbandIdFromConcerts < ActiveRecord::Migration[6.1]
  def change
    remove_column :concerts, :regionalverband_id, :integer
  end
end
