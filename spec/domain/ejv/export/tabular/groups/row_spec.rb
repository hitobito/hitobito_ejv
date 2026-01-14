# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Export::Tabular::Groups::Row do
  let(:row) { Export::Tabular::Groups::Row.new(group, []) }
  let(:group) { groups(:emmentaler_jodler_konolfingen) }

  subject { row }

  describe "Group::VereinJodler with values" do
    describe "recognized_members" do
      before do
        10.times do
          Fabricate(
            Group::VereinJodler::Mitglied.sti_name.to_sym,
            group: group
          )
        end
      end

      it "returns calculated" do
        expect(row.fetch(:recognized_members)).to eq 10
      end
    end
  end
end
