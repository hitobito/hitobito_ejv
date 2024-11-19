# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class CreateConcerts < ActiveRecord::Migration[4.2]
  def change
    create_table :concerts do |t|
      t.string :name, null: false

      t.belongs_to :verein, null: false
      t.belongs_to :mitgliederverband, index: true
      t.belongs_to :regionalverband, index: true
      t.belongs_to :song_census

      t.date :performed_at
      t.integer :year, null: false
      t.boolean :editable, default: true, null: false
    end

    remove_reference :song_counts, :verein
    remove_reference :song_counts, :mitgliederverband
    remove_reference :song_counts, :regionalverband
    remove_reference :song_counts, :song_census

    remove_column :song_counts, :editable

    add_reference :song_counts, :concert, foreign_key: true
  end
end
