#  Copyright (c) 2026-2026, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class RemoveManualMemberCountAttrsFromGroups < ActiveRecord::Migration[8.0]
  def change
    remove_column :groups, :manual_member_count, :integer, default: 0
    remove_column :groups, :manually_counted_members, :boolean, default: false, null: false
  end
end
