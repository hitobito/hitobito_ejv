# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class RemoveSecondaryParentsFromGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :secondary_parent_id, :integer
    remove_column :groups, :tertiary_parent_id, :integer
  end
end
