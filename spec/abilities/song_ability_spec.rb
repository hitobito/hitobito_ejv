# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SongAbility do
  subject { ability }

  let(:ability) { Ability.new(role.person.reload) }
  let(:concert) do
    concerts(:second_concert).tap do |concert|
      concert.infer_verband_ids
    end
  end
  let(:verein) { groups(:jodlergruppe_engstligtal_adelboden) }
  let(:group) { groups(:bkjv) }

  [
    %w[Group::Verein::Admin jodlergruppe_engstligtal_adelboden],
    %w[Group::Verein::Mitglied jodlergruppe_engstligtal_adelboden]
  ].each do |role, group|
    context role do
      let(:role) { Fabricate(role.to_sym, group: groups(group)) }

      it "may not index SongCensu" do
        is_expected.not_to be_able_to(:index, SongCensus)
      end

      it "may not manage SongCensus" do
        is_expected.not_to be_able_to(:manage, SongCensus)
      end

      context "in own group" do
        let(:song_count) { SongCount.new(concert: concert) }

        if /Mitglied$/.match?(role)
          it "may not read on song_count" do
            is_expected.not_to be_able_to(:read, song_count)
          end
        else
          it "may read on song_count" do
            is_expected.to be_able_to(:read, song_count)
          end
        end
      end
    end
  end

  describe "suisa_admin" do
    context "of layer above" do
      let(:role) { Fabricate(:"#{verein.parent.class}::SuisaAdmin", group: verein.parent) }

      context SongCount do
        it "may index_song_counts" do
          is_expected.to be_able_to(:index_song_counts, verein)
        end
      end
    end

    context "in same verein" do
      let(:role) { Fabricate(Group::Verein::SuisaAdmin.name.to_sym, group: verein) }

      context Concert do
        it "may manage concerts for verein" do
          is_expected.to be_able_to(:manage, concert)
        end

        it "may submit concerts for verein" do
          is_expected.to be_able_to(:submit, concert)
        end

        it "may create concerts for verein" do
          is_expected.to be_able_to(:create, concert)
        end
      end

      context Song do
        %w[create show].each do |action|
          it "may #{action} Song" do
            is_expected.to be_able_to(action.to_sym, Song.first)
          end
        end

        it "may index Song" do
          is_expected.to be_able_to(:index, Song)
        end

        %w[destroy edit update manage].each do |action|
          it "may not #{action} Song" do
            is_expected.not_to be_able_to(action.to_sym, Song.first)
          end
        end
      end

      context SongCount do
        it "may index_song_counts in verein" do
          is_expected.to be_able_to(:index_song_counts, verein)
        end

        it "may manage SongCounts owned by verein" do
          is_expected.to be_able_to(:manage, concert.song_counts.new)
        end

        it "may submit SongCounts owned by verein" do
          is_expected.to be_able_to(:submit, concert.song_counts.new)
        end
      end
    end

    context "of mitgliederverband can manager groups below, they" do
      let(:role) { Fabricate(Group::Mitgliederverband::SuisaAdmin.name.to_sym, group: group) }

      context Concert do
        it "may manage concerts for verein" do
          is_expected.to be_able_to(:manage, concert)
        end

        it "may submit concerts for verein" do
          is_expected.to be_able_to(:submit, concert)
        end

        it "may create concerts for verein if all values are set" do
          is_expected.to be_able_to(:create, concert)
        end

        it "may create concerts for verein if verband-relations are still unknown" do
          expect(concerts(:second_concert).mitgliederverband).to be_nil
          is_expected.to be_able_to(:create, concerts(:second_concert))
        end
      end

      context SongCount do
        it "may index_song_counts in verein" do
          is_expected.to be_able_to(:index_song_counts, verein)
        end

        it "may manage SongCounts owned by verein" do
          is_expected.to be_able_to(:manage, concert.song_counts.new)
        end

        it "may submit SongCounts owned by verein" do
          is_expected.to be_able_to(:submit, concert.song_counts.new)
        end
      end

      context SongCensus do
        it "may manage_song_census in same group" do
          is_expected.to be_able_to(:manage_song_census, group)
        end

        it "may not manage_song_census in layer above" do
          is_expected.not_to be_able_to(:manage_song_census, groups(:root))
        end

        it "may manage_song_census in groups below" do
          is_expected.to be_able_to(:manage_song_census, verein)
        end
      end
    end
  end
end
