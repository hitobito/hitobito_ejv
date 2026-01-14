# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Group do
  let(:group) { groups(:delegierte) }

  include_examples "group types", group_group_label: "Group::Verein"

  context "#song_counts" do
    subject { groups(:root) }

    it "is a scope" do
      expect(subject.song_counts).to be_a ActiveRecord::Relation
    end

    it "contains several song_counts" do
      expect(subject.song_counts.count).to be 4
    end

    it "does not include deleted groups" do
      expect(song_counts(:mama_count).concert.verein).to be_deleted

      expect(subject.song_counts).to_not include song_counts(:mama_count)
    end
  end
end
