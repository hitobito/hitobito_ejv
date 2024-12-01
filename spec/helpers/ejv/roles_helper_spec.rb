# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Ejv::RolesHelper do
  describe "#default_language_for_person" do
    let(:group) { groups(:root) }

    it "returns predefined language for group if preset" do
      group.correspondence_language = "de"
      language = default_language_for_person(group)

      expect(language).to eq("de")
    end

    it "returns predefined languages if language not set" do
      group.correspondence_language = nil
      language = default_language_for_person(group)

      expect(language).to eq(["Deutsch", :de])
    end
  end
end
