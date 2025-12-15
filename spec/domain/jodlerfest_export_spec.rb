# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"
require "mysql2"

describe JodlerfestExport do
  let(:client) { instance_double(Mysql2::Client) }
  let(:person) { people(:member) }

  subject(:export) { described_class.new(client) }

  subject(:data) { export.send(:data_map, model, mapping) }

  before do
    allow(client).to receive(:query)
    allow(client).to receive(:escape) { |arg| arg }
  end

  it "#run" do
    export.run
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
      expect(data["AdrEinzelmitglied"]).to eq "b'0'"
    end

    it "einzelmitglied" do
      Fabricate(Group::MitgliederverbandEinzelmitglieder::Jodler.sti_name,
        person: model,
        group: groups(:einzelmitglieder_nwsjv))

      expect(mapping).to have_key("AdrEinzelmitglied")
      expect(data["AdrEinzelmitglied"]).to eq "b'1'"
    end

    it "nicht nachwuchs" do
      expect(mapping).to have_key("AdrNachwuchs")
      expect(data["AdrNachwuchs"]).to eq "b'0'"
    end

    it "nachwuchs" do
      Fabricate(Group::MitgliederverbandNachwuchsmitglieder::Jodler.sti_name,
        person: model,
        group: groups(:nachwuchsmitglieder_nwsjv))

      expect(mapping).to have_key("AdrNachwuchs")
      expect(data["AdrNachwuchs"]).to eq "b'1'"
    end
  end

  context "group" do
    let(:model) { groups(:jodlerklub_gunzgen_olten) }
    let(:mapping) { export.send(:group_mapping) }

    it "id"
    it "dirigent"
    it "praesident"
    it "email"
    it "unterverband"
    it "typ"
    it "name"
    it "ort"
  end

  context "roles" do
    it "only relevant roles"
    it "person_id"
    it "group_id"
  end
end
