# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class AddPlaceholdersToSelectedCustomContents < ActiveRecord::Migration[4.2]
  def up
    each_applicable_custom_content do |content|
      placeholders = content.placeholders_optional + ", dachverband"
      content.update(placeholders_optional: placeholders)
    end
  end

  def down
    each_applicable_custom_content do |content|
      placeholders = content.placeholders_optional.gsub(', dachverband', '')
      content.update(placeholders_optional: placeholders)
    end
  end

  def each_applicable_custom_content
    [SongCensusMailer::SONG_CENSUS_REMINDER, Person::LoginMailer::CONTENT_LOGIN ].each do |key|
      custom_content = CustomContent.find_by(key: key)
      yield custom_content if custom_content
    end
  end
end
