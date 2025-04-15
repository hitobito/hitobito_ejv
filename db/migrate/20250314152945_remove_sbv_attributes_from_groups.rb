class RemoveSbvAttributesFromGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :correspondence_language, :string, limit: 5
    remove_column :groups, :besetzung, :string
    remove_column :groups, :klasse, :string
    remove_column :groups, :unterhaltungsmusik, :string
    remove_column :groups, :subventionen, :string
  end
end
