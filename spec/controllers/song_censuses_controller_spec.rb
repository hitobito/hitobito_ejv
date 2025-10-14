# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SongCensusesController do
  let(:group) { Fabricate(Group::Mitgliederverband.name.to_sym) }

  context "index" do
    let(:admin) { people(:admin) }

    before do
      Fabricate(Group::Mitgliederverband::SuisaAdmin.name.to_sym, group: group, person: admin)
      sign_in(admin)
    end

    it "shows which groups have submitted a census" do
      get :index, params: {group_id: group.id}

      expect(response).to have_http_status(:ok)
    end
  end

  context "remind" do
    let(:song_census) { song_censuses(:two_o_18) }
    let(:verein1) { Fabricate(Group::VereinJodler.name.to_sym, parent: group) }
    let(:verein2) { Fabricate(Group::VereinJodler.name.to_sym, parent: group) }

    before do
      sign_in(people(:suisa_admin))

      Fabricate(Group::Mitgliederverband::SuisaAdmin.name.to_sym, group: group,
        person: people(:suisa_admin))
      2.times { Fabricate(Group::VereinJodler::SuisaAdmin.name.to_sym, group: verein1) }
      Fabricate(Group::VereinJodler::SuisaAdmin.name.to_sym, group: verein2)
    end

    xit "reminds suisa_admins" do
      ref = @request.env["HTTP_REFERER"] = group_song_censuses_path(group, song_census)

      expect do
        post :remind, params: {group_id: group, song_census_id: song_census}
      end.to change { ActionMailer::Base.deliveries.size }.by 3

      is_expected.to redirect_to(ref)
    end
  end
end
