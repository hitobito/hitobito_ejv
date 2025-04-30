# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class RemoveHostnameFromGroups < ActiveRecord::Migration[7.1]
  def change
    remove_index :groups, :hostname, unique: true
    remove_column :groups, :hostname, :string
  end
end
