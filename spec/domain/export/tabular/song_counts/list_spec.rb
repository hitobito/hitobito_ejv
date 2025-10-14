# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"
require "csv"

describe Export::Tabular::SongCounts::List do
  let(:data) { Export::Tabular::SongCounts::List.csv(list) }
  let(:data_without_bom) { data.gsub(Regexp.new("^#{Export::Csv::UTF8_BOM}"), "") }
  let(:csv) { CSV.parse(data_without_bom, headers: true, col_sep: Settings.csv.separator) }
  let(:sorted_csv) { csv.sort_by { |r| [r["SUISA-ID"], r["Titel"]].join(" ") } }

  subject { csv }

  context "verein" do
    let(:list) { groups(:jodlergruppe_engstligtal_adelboden).song_counts.order(:concert_id) }

    its(:headers) do
      is_expected.to eql ["Anzahl", "Titel", "Komponist", "Arrangeur", "Verlag", "SUISA-ID",
        "Verein", "Vereins ID"]
    end

    it "has 2 items" do
      expect(subject.size).to eq(2)
    end

    context "first row" do
      subject { sorted_csv[0] }

      its(["Anzahl"]) { is_expected.to eql "12" }
      its(["Titel"]) { is_expected.to eql "Fortunate Son" }
      its(["Komponist"]) { is_expected.to eql "John Fogerty" }
      its(["Arrangeur"]) { is_expected.to eql "Creedence Clearwater Revival" }
      its(["Verlag"]) { is_expected.to eql "Fantasy" }
      its(["SUISA-ID"]) { is_expected.to eql "12345" }
      its(["Verein"]) { is_expected.to eql "Jodlergruppe Engstligtal Adelboden" }
      its(["Vereins ID"]) { is_expected.to eql groups(:jodlergruppe_engstligtal_adelboden).id.to_s }
    end

    context "second row" do
      subject { sorted_csv[1] }

      its(["Anzahl"]) { is_expected.to eql "8" }
      its(["Titel"]) { is_expected.to eql "Papa Was a Rollin' Stone" }
      its(["Komponist"]) { is_expected.to eql "Barrett Strong / Norman Whitfield" }
      its(["Arrangeur"]) { is_expected.to eql "The Temptations" }
      its(["Verlag"]) { is_expected.to eql "Motown" }
      its(["SUISA-ID"]) { is_expected.to eql "23456" }
      its(["Verein"]) { is_expected.to eql "Jodlergruppe Engstligtal Adelboden" }
      its(["Vereins ID"]) { is_expected.to eql groups(:jodlergruppe_engstligtal_adelboden).id.to_s }
    end
  end

  xcontext "group" do
    let(:list) { groups(:root).song_counts.order(:concert_id) }

    its(:headers) do
      is_expected.to eql ["Anzahl", "Titel", "Komponist", "Arrangeur", "Verlag", "SUISA-ID",
        "Verein und Ort"]
    end

    it "has 4 items" do
      expect(subject.size).to eq(4)
    end

    context "first row" do
      subject { sorted_csv[0] }

      its(["Anzahl"]) { is_expected.to eql "12" }
      its(["Titel"]) { is_expected.to eql "Fortunate Son" }
      its(["Komponist"]) { is_expected.to eql "John Fogerty" }
      its(["Arrangeur"]) { is_expected.to eql "Creedence Clearwater Revival" }
      its(["Verlag"]) { is_expected.to eql "Fantasy" }
      its(["SUISA-ID"]) { is_expected.to eql "12345" }
      its(["Verein und Ort"]) { is_expected.to eql "Jodlergruppe Engstligtal Adelboden" }
    end

    context "second row" do
      subject { sorted_csv[1] }

      its(["Anzahl"]) { is_expected.to eql "8" }
      its(["Titel"]) { is_expected.to eql "Papa Was a Rollin' Stone" }
      its(["Komponist"]) { is_expected.to eql "Barrett Strong / Norman Whitfield" }
      its(["Arrangeur"]) { is_expected.to eql "The Temptations" }
      its(["Verlag"]) { is_expected.to eql "Motown" }
      its(["SUISA-ID"]) { is_expected.to eql "23456" }
      its(["Verein und Ort"]) { is_expected.to eql "Jodlergruppe Engstligtal Adelboden" }
    end

    context "third row" do
      subject { sorted_csv[2] }

      its(["Anzahl"]) { is_expected.to eql "4" }
      its(["Titel"]) { is_expected.to eql "Papa Was a Rollin' Stone" }
      its(["Komponist"]) { is_expected.to eql "Barrett Strong / Norman Whitfield" }
      its(["Arrangeur"]) { is_expected.to eql "The Temptations" }
      its(["Verlag"]) { is_expected.to eql "Motown" }
      its(["SUISA-ID"]) { is_expected.to eql "23456" }
      its(["Verein und Ort"]) { is_expected.to eql "Jodlerklub Edelweiss Thun" }
    end

    context "fourth row" do
      subject { sorted_csv[3] }

      its(["Anzahl"]) { is_expected.to eql "2" }
      its(["Titel"]) { is_expected.to eql "Material Girl" }
      its(["Komponist"]) { is_expected.to eql "Peter Brown / Robert Rans" }
      its(["Arrangeur"]) { is_expected.to eql "Madonna" }
      its(["Verlag"]) { is_expected.to eql "Sire" }
      its(["SUISA-ID"]) { is_expected.to eql "34567" }
      its(["Verein und Ort"]) { is_expected.to eql "Jodlerklub Edelweiss Thun" }
    end
  end
end
