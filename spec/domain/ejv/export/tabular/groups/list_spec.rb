# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Export::Tabular::Groups::List do
  let(:subject) { Export::Tabular::Groups::List.new([groups(:root)]) }

  it "does includes computed recognized_members attribute" do
    expect(subject.attributes).to include(:recognized_members)
  end
end
