# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::Verein < ::Group
  # HIDDEN_ROOT_VEREIN_NAME = "Ehemalige aus Verlauf"

  self.layer = true

  self.used_attributes += [:founding_year,
    :manually_counted_members,
    :manual_member_count,
    :recognized_members]

  has_many :concerts, dependent: :destroy
  has_many :song_counts, through: :concerts

  # def self.hidden
  #   root = Group::Root.first
  #   verein = Group::VereinJodler.deleted.find_by(name: HIDDEN_ROOT_VEREIN_NAME, parent: root)
  #   return verein if verein
  #
  #   Group::VereinJodler.new(
  #     name: HIDDEN_ROOT_VEREIN_NAME,
  #     parent: root,
  #     deleted_at: Time.zone.now
  #   ).tap do |verein|
  #     verein._skip_default_children = true
  #     verein.save!
  #   end
  # end

  # TODO: Validierungen der verschiedenen Values, refactoring, exports

  def last_played_song_ids
    year = Time.zone.now.year

    SongCount.where(concert: concerts.in([year, year - 1]))
      .pluck(:song_id)
      .uniq
  end
end
