# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe CensusSubmission do
  let(:census) { song_censuses(:two_o_18) }
  let(:group) { groups(:jodlergruppe_engstligtal_adelboden) }

  subject { described_class.new(group, census) }

  it "submits song_counts by linking them to a census" do
    concerts(:first_concert).update(song_census: nil)

    expect do
      expect(subject.submit).to be_truthy
    end.to change { Concert.where(song_census: nil).count }.by(-1)
  end

  it "does not change rows if everything is submitted already" do
    expect do
      expect(subject.submit).to be_falsey
    end.to_not change { Concert.where(song_census: nil).count }
  end
end
