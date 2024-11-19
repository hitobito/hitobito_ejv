# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class AddSecondParticipantToGroupApplications < ActiveRecord::Migration[4.2]
  def change
    change_table :event_group_participations do |t|
      t.rename :state, :primary_state

      t.boolean :joint_participation, null: false, default: false
      t.string :secondary_state, null: false
      t.belongs_to :secondary_group
      t.boolean :secondary_group_terms_accepted, null: false, default: false
    end
  end
end
