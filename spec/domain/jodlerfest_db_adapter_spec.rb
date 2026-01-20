# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"
require "mysql2"

describe JodlerfestDbAdapter do
  let(:client) { instance_double(Mysql2::Client) }
  let(:person) { people(:member) }
  let(:export) { JodlerfestDbExport.new(adapter) }

  subject(:adapter) { described_class.new(client) }

  subject(:data) { adapter.data_map(model, mapping) }

  before do
    allow(client).to receive(:query)
    allow(client).to receive(:escape) { |arg| arg }
  end

  context "person" do
    let(:model) { Fabricate(:person, birthday: "2025-10-12") }
    let(:mapping) { export.send(:person_mapping) }

    it "birthday" do
      expect(mapping).to have_key("AdrGeburtsdatum")
      expect(data["AdrGeburtsdatum"]).to eq '"2025-10-12"'
    end

    it "unterverband" do
      Fabricate(Group::VereinJodler::Mitglied.sti_name, person: model,
        group: groups(:jodlerklub_gunzgen_olten))

      expect(mapping).to have_key("AdrUv")
      expect(data["AdrUv"]).to eq '"NWSJV"'
    end

    it "nicht einzelmitglied" do
      expect(mapping).to have_key("AdrEinzelmitglied")
      expect(data["AdrEinzelmitglied"]).to eq "0"
    end

    it "einzelmitglied" do
      Fabricate(Group::MitgliederverbandEinzelmitglieder::Jodler.sti_name,
        person: model,
        group: groups(:einzelmitglieder_nwsjv))

      expect(mapping).to have_key("AdrEinzelmitglied")
      expect(data["AdrEinzelmitglied"]).to eq "1"
    end

    it "nicht nachwuchs" do
      expect(mapping).to have_key("AdrNachwuchs")
      expect(data["AdrNachwuchs"]).to eq "0"
    end

    it "nachwuchs" do
      Fabricate(Group::MitgliederverbandNachwuchsmitglieder::Jodler.sti_name,
        person: model,
        group: groups(:nachwuchsmitglieder_nwsjv))

      expect(mapping).to have_key("AdrNachwuchs")
      expect(data["AdrNachwuchs"]).to eq "1"
    end
  end

  context "group" do
    let(:model) { groups(:jodlerklub_gunzgen_olten) }
    let(:mapping) { export.send(:group_mapping) }

    it "name" do
      expect(mapping).to have_key("GruName")
      expect(data["GruName"]).to eq '"Jodlerklub Gunzgen-Olten"'
    end

    it "longer name gets truncated" do
      adapter.instance_variable_set(:@schema_limits, {"GruName" => 30})
      model.name = "Jodlerklub Gunzgen-Olten-Obergösgen-Däniken-Starkirch-und-Umgebung"

      expect(mapping).to have_key("GruName")
      expect(data["GruName"]).to eq '"Jodlerklub Gunzgen-Olten-Oberg"'
    end
  end
end
