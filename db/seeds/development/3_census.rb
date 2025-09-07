# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# past years
[Date.today.year - 2, Date.today.year - 1].each do |year|
  SongCensus.seed_once(:year) do |census|
    census.year = year
    census.start_at = Date.new(year - 1, 12, 1)
    census.finish_at = Date.new(year, 11).end_of_month
  end
end

# current census
[Date.today.year].each do |year|
  SongCensus.seed_once(:year) do |census|
    census.year = year
    census.start_at = Date.new(year - 1, 12, 1)
    census.finish_at = Date.new(year, 11).end_of_month
  end
end

current_census = SongCensus.current
songs = Song.all.shuffle.take(10)

SongCensus.all.each do |census|
  Group::VereinJodler.all.shuffle.take(10).each do |verein|
    rand(1..6).times do
      Concert.seed_once(:name, :song_census_id, :verein_id) do |concert|
        concert.name = Faker::Company.name
        concert.song_census_id = census.id
        concert.verein_id = verein.id
        concert.mitgliederverband_id = verein.parent.parent.id if verein.parent.try(:parent).is_a?(Group::Mitgliederverband)
        concert.year = census.year
        concert.editable = true
      end
    end
    Concert.all.each do |concert|
      songs.shuffle.take(10).each do |song|
        SongCount.seed_once(:concert_id, :song_id) do |count|
          count.concert_id = concert.id
          count.song_id = song.id
          count.year = census.year
          count.count = Faker::Number.between(from: 0, to: 30)
        end
      end

      concert.update(editable: (census == current_census))
    end
  end
end
