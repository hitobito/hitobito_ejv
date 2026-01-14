# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::Verein < ::Group
  self.layer = true

  self.used_attributes += [:association_entry,
    :recognized_members]

  has_many :concerts, dependent: :destroy
  has_many :song_counts, through: :concerts

  # TODO: Validierungen der verschiedenen Values, refactoring, exports

  def last_played_song_ids
    year = Time.zone.now.year

    SongCount.where(concert: concerts.in([year, year - 1]))
      .pluck(:song_id)
      .uniq
  end
end
