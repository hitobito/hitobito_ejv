# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class AddPreferredPlayDaysOnGroupParticipations < ActiveRecord::Migration[4.2]
  def change
    add_column :event_group_participations, :preferred_play_day_1, :integer
    add_column :event_group_participations, :preferred_play_day_2, :integer
  end
end
