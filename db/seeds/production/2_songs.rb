# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


require 'csv'

CSV::Converters[:nil] = lambda { |f| f == "\\N" ? nil : f.encode(CSV::ConverterEncoding) rescue f }
CSV::Converters[:all] = [:numeric, :nil]

if Wagons.find('ejv').root.join('db/seeds/production/suisa_werke.csv').exist?
  CSV.parse(Wagons.find('ejv').root.join('db/seeds/production/suisa_werke.csv').read.gsub('\"', '""'), headers: true, converters: :all).each do |song|
    Song.seed_once(:suisa_id, song.to_hash)
  end
end
