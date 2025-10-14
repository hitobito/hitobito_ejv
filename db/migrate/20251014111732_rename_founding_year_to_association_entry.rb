class RenameFoundingYearToAssociationEntry < ActiveRecord::Migration[7.1]
  def change
    rename_column :groups, :founding_year, :association_entry
  end
end
