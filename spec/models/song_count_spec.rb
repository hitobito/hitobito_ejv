# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SongCount do
  it "#empty? treats blank count as true" do
    subject.count = nil
    expect(subject).to be_empty
    subject.count = ""
    expect(subject).to be_empty
  end

  context "validations" do
    it "cannot set count over 30" do
      song_count = SongCount.create(count: 31)
      expect(song_count).not_to be_valid
      expect(song_count.errors.full_messages).to include("Anzahl muss kleiner oder gleich 30 sein")
    end

    it "cannot set count less then zero" do
      song_count = SongCount.create(count: -1)
      expect(song_count).not_to be_valid
      expect(song_count.errors.full_messages).to include("Anzahl muss grösser oder gleich 1 sein")
    end
  end
end
