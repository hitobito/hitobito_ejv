# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module ConcertsHelper
  def concerts_view_tabs(group)
    content_tag(:div, class: "toolbar-pills mb-2") do
      content_tag(:ul, class: "nav nav-pills group-pills border border-primary rounded") do
        safe_join(tabs(group)) do |title, path|
          content_tag(:li,
            link_to(
              title,
              path,
              class: "nav-link rounded-0 py-1 px-3 mr-0 #{"active" if active(path)}"
            ),
            class: "nav-item border-start border-primary")
        end
      end
    end
  end

  private

  def tabs(group)
    [
      [t("concerts.actions_index.concerts"), group_concerts_path(group)],
      [t("concerts.actions_index.summary"), group_song_counts_path(group)]
    ]
  end

  def active(path)
    path == request.path
  end
end
