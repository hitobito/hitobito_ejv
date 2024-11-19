# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module SongCountsHelper
  def song_counts_update_button(action)
    icon = icon((action == :inc) ? "chevron-right" : "chevron-left")
    link_to(icon, "#", class: "#{action}_song_count")
  end

  def song_counts_export_dropdown
    Dropdown::SongCounts.new(self, params, :download).export
  end
end
