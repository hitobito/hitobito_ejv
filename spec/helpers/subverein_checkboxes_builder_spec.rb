# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SubvereinCheckboxesBuilder do
  describe "#vereine_nesting" do
    let(:root) { groups(:bernischer_kantonal_musikverband) }
    let(:vereine) { Group.where(id: [groups(:musikgesellschaft_aarberg).id]) }

    subject { described_class.new(root, nil) }

    it "needs me to understand a complex datastructure, so let's try to detangle this" do
      vereine_nesting = subject.send(:vereine_nesting)

      # simplify structure-content, made with pride in pry
      name_mapped_groups = vereine_nesting.map do |k, v|
        [k.to_s, v.map do |k, v|
          [k.to_s, v.map(&:to_s)]
        end.to_h]
      end.to_h

      expect(name_mapped_groups).to eq({
        root.to_s => {
          root.to_s => [
            "Jodlerklub Edelweiss Thun",
            "Jodlerklub Berna Bern",
            "Jodlergruppe Engstligtal Adelboden",
            "Emmentaler-Jodler Konolfingen"
          ]
        }
      })

      expect(name_mapped_groups[root.to_s][root.to_s]).to match_array(vereine.map(&:to_s))
    end

    it "creates nesting" do
      nesting = subject.send(:vereine_nesting)
      expected = {}
      expected[root] = {}
      expected[root][root] = vereine

      expect(nesting).to eq(expected)
    end
  end
end
