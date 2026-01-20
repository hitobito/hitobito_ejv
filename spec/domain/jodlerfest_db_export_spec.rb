# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"
require "mysql2"

describe JodlerfestDbExport do
  let(:client) { instance_double(Mysql2::Client) }
  let(:adapter) { JodlerfestDbAdapter.new(client) }

  let(:person) { people(:member) }

  subject(:export) { described_class.new(adapter) }

  subject(:data) { adapter.data_map(model, mapping) }

  before do
    allow(client).to receive(:query)
    allow(client).to receive(:escape) { |arg| arg }
  end

  context "integrates with adapter and client" do
    let(:adapter_double) { object_double(adapter).as_null_object }

    subject(:mocked_export) { described_class.new(adapter_double) }

    it "#run" do
      expect(adapter_double).to receive(:send_data).with("adressenstamm", any_args).twice
      expect(adapter_double).to receive(:send_data).with("gruppen", any_args)
      expect(adapter_double).to receive(:send_data).with("gruppenmitglieder", any_args)

      mocked_export.run
    end
  end

  context "person" do
    let(:model) { Fabricate(:person, birthday: "2025-10-12") }
    let(:mapping) { export.send(:person_mapping) }

    it "birthday" do
      expect(mapping).to have_key("AdrGeburtsdatum")
      expect(data["AdrGeburtsdatum"]).to eq '"2025-10-12"'
    end

    it "phonenumber" do
      Fabricate(:phone_number, contactable: model, number: "+41 79 123 45 67")
      model.reload

      expect(mapping).to have_key("AdrTelM")
      expect(data["AdrTelM"]).to eq '"+41 79 123 45 67"'
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

    it "id with offset" do
      model.update(id: 250_000)
      expect(mapping).to have_key("GruAdrNr")
      expect(data["GruAdrNr"]).to eq model.id + 1_000_000
    end

    it "id without offset" do
      model.update(id: 12_345)

      expect(mapping).to have_key("GruAdrNr")
      expect(data["GruAdrNr"]).to eq model.id
    end

    it "dirigent" do
      role = Fabricate(Group::VereinJodler::Conductor.sti_name, group: model)

      expect(mapping).to have_key("GruAdrNrDirigent")
      expect(data["GruAdrNrDirigent"]).to eq role.person_id
    end

    it "praesident" do
      role = Fabricate(Group::VereinJodler::Praesident.sti_name, group: model)

      expect(mapping).to have_key("GruAdrNrPraesident")
      expect(data["GruAdrNrPraesident"]).to eq role.person_id
    end

    it "email" do
      expect(mapping).to have_key("GruMail")
      expect(data["GruMail"]).to eq '"olten@example.org"'
    end

    it "unterverband" do
      expect(mapping).to have_key("GruUV")
      expect(data["GruUV"]).to eq '"NWSJV"'
    end

    it "typ" do
      expect(mapping).to have_key("GruTyp")
      expect(data["GruTyp"]).to eq '"Jodler-Gruppe"'
    end

    it "name" do
      expect(mapping).to have_key("GruName")
      expect(data["GruName"]).to eq '"Jodlerklub Gunzgen-Olten"'
    end

    it "ort" do
      expect(mapping).to have_key("GruOrt")
      expect(data["GruOrt"]).to eq '"Olten"'
    end
  end

  context "roles" do
    let(:model) { roles(:member) }
    let(:mapping) { export.send(:role_mapping) }

    it "only relevant roles" do
      expect(export.send(:relevant_role_types)).to match_array([
        "Group::VereinJodler::Mitglied",
        "Group::VereinJodlerNachwuchs::Mitglied",
        "Group::VereinAlphornblaeser::Mitglied",
        "Group::VereinAlphornblaeserNachwuchs::Mitglied",
        "Group::VereinFahnenschwinger::Mitglied",
        "Group::VereinFahnenschwingerNachwuchs::Mitglied"
      ])
    end

    it "person_id" do
      expect(mapping).to have_key("GmiEjvNr")
      expect(data["GmiEjvNr"]).to eq model.person_id
    end

    it "group_id with offset" do
      expect(model.group_id).to eq 51155821 # i.e. bigger than threshold

      expect(mapping).to have_key("GmiEjvNrGrp")
      expect(data["GmiEjvNrGrp"]).to eq model.group_id + 1_000_000
    end

    it "group_id without offset" do
      model.update(group_id: 44733) # i.e. lower than threshold
      expect(model.group_id).to eq 44733

      expect(mapping).to have_key("GmiEjvNrGrp")
      expect(data["GmiEjvNrGrp"]).to eq model.group_id
    end
  end

  context "group addresses" do
    let(:model) { groups(:jodlerklub_gunzgen_olten) }
    let(:mapping) { export.send(:group_addresses_mapping) }

    it "exports the id with less conflicts" do
      expect(model.id).to eq 547334049

      expect(mapping).to have_key("AdrNr")
      expect(data["AdrNr"]).to eq(model.id + 1_000_000)
    end

    it "export older ids 'as is'" do
      model.update(id: 12345)

      expect(mapping).to have_key("AdrNr")
      expect(data["AdrNr"]).to eq(model.id)
    end

    it "export ids until 200_000 'as is'" do
      model.update(id: 200_000)

      expect(mapping).to have_key("AdrNr")
      expect(data["AdrNr"]).to eq(model.id)
    end

    it "export ids from 200_000 on with offset" do
      model.update(id: 200_001)

      expect(mapping).to have_key("AdrNr")
      expect(data["AdrNr"]).to eq(model.id + 1_000_000)
    end
  end
end
