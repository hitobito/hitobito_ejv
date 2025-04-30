# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe GroupAbility do
  subject { Ability.new(role.person.reload) }

  let(:role) { Fabricate(group_role_class.name.to_sym, group: group) }

  describe "delete people" do
    let(:checked_person) { Fabricate(:person, primary_group: checked_group) }
    let!(:checked_person_role) do
      Fabricate(Group::VereinMitglieder::Mitglied.name.to_sym,
        group: checked_group.children.where(type: Group::VereinMitglieder.sti_name).first,
        person: checked_person)
    end

    context "as admin of dachverband" do
      let(:group_role_class) { Group::Root::Admin }
      let(:group) { groups(:root) }
      let(:checked_group) { groups(:jodlergruppe_engstligtal_adelboden) }

      it { is_expected.to be_able_to(:destroy, checked_person) }
    end

    context "as admin of mitgliederverband" do
      let(:group_role_class) { Group::Mitgliederverband::Admin }
      let(:group) { groups(:bkjv) }
      let(:checked_group) { groups(:jodlergruppe_engstligtal_adelboden) }

      it { is_expected.to be_able_to(:destroy, checked_person) }
    end

    context "as admin of group" do
      let(:group_role_class) { Group::Verein::Admin }
      let(:group) { groups(:jodlergruppe_engstligtal_adelboden) }
      let(:checked_group) { group }

      it { is_expected.not_to be_able_to(:destroy, checked_person) }
    end

    context "as admin of different group" do
      let(:group_role_class) { Group::Verein::Admin }
      let(:group) { groups(:jodlergruppe_engstligtal_adelboden) }
      let(:checked_group) { groups(:jodlerklub_edelweiss_thun) }

      it { is_expected.not_to be_able_to(:destroy, checked_person) }
    end

    context "as member of a group" do
      let(:group_role_class) { Group::VereinMitglieder::Mitglied }
      let(:group) { groups(:mitglieder_adelboden) }
      let(:checked_group) { group.layer_group }

      it { is_expected.not_to be_able_to(:destroy, checked_person) }
    end
  end

  describe "show deleted_subgroups" do
    context "as admin of group" do
      let(:group_role_class) { Group::Verein::Admin }
      let(:group) { groups(:jodlergruppe_engstligtal_adelboden) }
      let(:checked_group) { group }

      it { is_expected.to be_able_to(:deleted_subgroups, checked_group) }
    end

    context "as admin of different group" do
      let(:group_role_class) { Group::Verein::Admin }
      let(:group) { groups(:jodlerklub_edelweiss_thun) }
      let(:checked_group) { groups(:jodlergruppe_engstligtal_adelboden) }

      it { is_expected.not_to be_able_to(:deleted_subgroups, checked_group) }
    end
  end

  context "finance" do
    let(:role) { Fabricate(Group::MitgliederverbandVorstand::Kassier.name.to_sym, group: groups(:vorstand_bkjv)) }

    it "may not show subverein_select on random group" do
      is_expected.not_to be_able_to(:subverein_select, Group.new)
    end

    it "may not show subverein_select in own group" do
      is_expected.not_to be_able_to(:subverein_select, groups(:vorstand_bkjv))
    end

    it "may not show subverein_select in layer below" do
      is_expected.not_to be_able_to(:subverein_select, groups(:jodlergruppe_engstligtal_adelboden))
    end

    it "may show subverein_select in layer" do
      is_expected.to be_able_to(:subverein_select, groups(:bkjv))
    end
  end
end
