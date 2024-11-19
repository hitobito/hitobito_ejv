# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class AddTermsAcceptedToGroupParticipations < ActiveRecord::Migration[4.2]
  def change
    change_table :event_group_participations do |t|
      t.boolean :terms_accepted, null: false, default: false
    end
  end
end
