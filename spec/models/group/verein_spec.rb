# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Group::Verein do
  context "recognized_members" do
    let(:verein) { groups(:emmentaler_jodler_konolfingen) }

    before do
      10.times do
        Fabricate(Group::VereinJodler::Mitglied.sti_name.to_sym, group: verein)
      end
    end

    it "returns automatically calulated" do
      expect(verein.recognized_members).to eq(10)
    end
  end
end
