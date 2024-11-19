# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class AddDeletedAtToConcertsAndSongcounts < ActiveRecord::Migration[6.0]
  def change
    add_column :concerts, :deleted_at, :datetime
    add_index  :concerts, :deleted_at

    add_column :song_counts, :deleted_at, :datetime
    add_index  :song_counts, :deleted_at
  end
end
