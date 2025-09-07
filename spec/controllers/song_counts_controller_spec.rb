# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SongCountsController do
  let(:group) { Fabricate(Group::Mitgliederverband.name.to_sym) }
  let(:verein) { Fabricate(Group::VereinJodler.name.to_sym, parent: group, name: "Jodlerei Sursee") }

  context "index" do
    let(:admin) { people(:admin) }

    before do
      Fabricate(Group::VereinJodler::SuisaAdmin.name.to_sym, group: verein, person: admin)
      Fabricate(Group::Mitgliederverband::SuisaAdmin.name.to_sym, group: group, person: admin)
      sign_in(admin)
    end

    it "exports csv" do
      get :index, params: {group_id: verein}, format: :csv
      expect(flash[:notice]).to eq "Export wird im Hintergrund gestartet und nach Fertigstellung heruntergeladen."
      expect(response).to redirect_to group_concerts_path(verein)
    end

    it "exports xlsx" do
      get :index, params: {group_id: group}, format: :xlsx
      expect(flash[:notice]).to eq "Export wird im Hintergrund gestartet und nach Fertigstellung heruntergeladen."
      expect(response).to redirect_to group_song_censuses_path(group)
    end
  end
end
