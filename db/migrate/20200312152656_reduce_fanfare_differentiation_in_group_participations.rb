# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class ReduceFanfareDifferentiationInGroupParticipations < ActiveRecord::Migration[4.2]
  def up
    say_with_time 'Mapping Fanfare Benelux' do
      execute <<-SQL.strip_heredoc.split.join(' ')
        UPDATE event_group_participations
        SET music_type = 'fanfare_benelux'
        WHERE music_type IN ('fanfare_benelux_harmony', 'fanfare_benelux_brass_band')
      SQL
    end

    say_with_time 'Mapping Fanfare Mixte' do
      execute <<-SQL.strip_heredoc.split.join(' ')
        UPDATE event_group_participations
        SET music_type = 'fanfare_mixte'
        WHERE music_type IN ('fanfare_mixte_harmony', 'fanfare_mixte_brass_band')
      SQL
    end
  end

  def down
    say_with_time 'Mapping Fanfare Benelux' do
      execute <<-SQL.strip_heredoc.split.join(' ')
        UPDATE event_group_participations
        SET music_type = 'fanfare_benelux_harmony'
        WHERE music_type = 'fanfare_benelux'
      SQL
    end

    say_with_time 'Mapping Fanfare Mixte' do
      execute <<-SQL.strip_heredoc.split.join(' ')
        UPDATE event_group_participations
        SET music_type = 'fanfare_mixte_harmony'
        WHERE music_type = 'fanfare_benelux'
      SQL
    end
  end
end
