# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Group::Verein do
  let(:hidden) { described_class.hidden }

  it "hidden verein creates hidden verein in root group without children" do
    expect(hidden).to be_deleted
    expect(hidden.reload).to have(0).children
  end

  it "hidden verein may have additional deleted children" do
    Group::VereinMitglieder.create!(name: "dummy", parent: hidden, deleted_at: Time.zone.now)
    expect(hidden).to be_deleted
    expect(hidden.reload).to have(1).children
    expect(hidden.children.first).to be_deleted
  end

  context "recognized_members" do
    let(:verein) { described_class.create(name: "Dummy Verein", parent: Group::Root.first, created_at: Time.zone.now) }

    before do
      mitglieder = Group::VereinMitglieder.create!(name: "dummy", parent: verein, deleted_at: Time.zone.now)

      10.times.each do |i|
        p = Fabricate(:person)
        Group::VereinMitglieder::Mitglied.create!(person: p, group: mitglieder)
      end
    end

    context "when manually_counted_members is false" do
      it "returns automatically calulated" do
        expect(verein.manually_counted_members).to eq(false)
        expect(verein.recognized_members).to eq(10)
      end
    end

    context "when manually_counted_members is true" do
      it "returns manually reported count if manual count is nonzero" do
        verein.update(manually_counted_members: true, manual_member_count: 20)

        expect(verein.manually_counted_members).to eq(true)
        expect(verein.recognized_members).to eq(20)
      end

      it "returns automatically calulated if manual count is zero" do
        verein.update(manually_counted_members: true, manual_member_count: 0)

        expect(verein.manually_counted_members).to eq(true)
        expect(verein.recognized_members).to eq(10)
      end
    end
  end
end
