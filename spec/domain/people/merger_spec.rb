# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe People::Merger do
  let(:person) { Fabricate(:person) }
  let(:duplicate) { Fabricate(:person_with_address_and_phone) }
  let(:actor) { people(:admin) }
  let(:person_roles) { person.roles.with_inactive }

  let(:merger) { described_class.new(@source.reload, @target.reload, actor) }

  before do
    Fabricate("Group::RootDelegierte::Mitglied",
      group: groups(:delegierte),
      person: duplicate,
      start_on: 5.seconds.ago,
      end_on: Time.zone.now)
  end

  context "merge people" do
    it "merges roles and considers created_at validations" do
      @source = duplicate
      @target = person

      expect do
        merger.merge!
      end.to change(Person, :count).by(-1)

      person.reload

      expect(person_roles.count).to eq(1)
      group_ids = person_roles.map(&:group_id)
      expect(group_ids).to include(groups(:delegierte).id)

      expect(Person.where(id: duplicate.id)).not_to exist
    end
  end
end
