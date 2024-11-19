# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class RemoveObsoleteAttributesFromEventGroupParticipations < ActiveRecord::Migration[6.1]
  def change
    remove_column :event_group_participations, :preferred_play_day_1, :integer
    remove_column :event_group_participations, :preferred_play_day_2, :integer
    remove_column :event_group_participations, :terms_accepted, :boolean
    remove_column :event_group_participations, :secondary_group_terms_accepted, :boolean
  end
end
