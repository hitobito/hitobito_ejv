# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Export::Tabular::Groups::Row do
  let(:row) { Export::Tabular::Groups::Row.new(group, []) }
  let(:group) { Group::Verein.new }

  subject { row }

  xdescribe "Group::Verein with values" do
    describe "recognized_members" do
      before do
        mitglieder = Group::Verein.create!(name: "dummy", parent: group.parent, deleted_at: Time.zone.now)

        10.times.each do |i|
          p = Fabricate(:person)
          Group::Verein::Mitglied.create!(person: p, group: mitglieder)
        end
      end

      context "when manually_counted_members is false" do
        it "returns calculated" do
          expect(group.manually_counted_members).to eq(false)

          expect(row.fetch(:recognized_members)).to eq 10
        end
      end

      context "when manually_counted_members is true" do
        it "returns manually reported count if manual count is nonzero" do
          group.update(manually_counted_members: true, manual_member_count: 20)

          expect(group.manually_counted_members).to eq(true)

          expect(row.fetch(:recognized_members)).to eq 20
        end

        it "returns automatically calulated if manual count is zero" do
          group.update(manually_counted_members: true, manual_member_count: 0)

          expect(group.manually_counted_members).to eq(true)

          expect(row.fetch(:recognized_members)).to eq 10
        end
      end
    end
  end
end
