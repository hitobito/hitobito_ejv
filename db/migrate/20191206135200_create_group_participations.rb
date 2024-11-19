# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class CreateGroupParticipations < ActiveRecord::Migration[4.2]
  def change
    create_table :event_group_participations do |t|
      t.string :state, null: false

      t.references :event, null: false
      t.references :group, null: false

      t.string :music_style
      t.string :music_type
      t.string :music_level

      t.timestamps null: false
    end

    add_index(:event_group_participations, [:event_id, :group_id], unique: true)
  end
end
