# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe InvoiceRuns::VereinMembershipFeeRecipientFinder do
  let(:verein) { Fabricate(Group::VereinJodler.sti_name.to_sym, parent: groups(:bkjv)) }
  let(:vorstand) { verein }

  describe "#find_recipient" do
    subject { InvoiceRuns::VereinMembershipFeeRecipientFinder.find_recipient(verein.id) }

    context "with only admin role" do
      let!(:admin_role) { Fabricate(Group::VereinJodler::Admin.sti_name.to_sym, group: verein) }

      it "finds admin role" do
        expect(subject).to eq(admin_role)
      end
    end

    context "with verein vorstand" do
      xcontext "with only kassier role" do
        let!(:kassier_role) {
          Fabricate(Group::VereinJodler::Kassier.sti_name.to_sym, group: vorstand)
        }

        it "finds kassier role" do
          expect(subject).to eq(kassier_role)
        end
      end

      context "with only praesident role" do
        let!(:praesident_role) {
          Fabricate(Group::VereinJodler::Praesident.sti_name.to_sym, group: vorstand)
        }

        it "finds praesident role" do
          expect(subject).to eq(praesident_role)
        end
      end

      xcontext "with admin, kassier and praesident role" do
        let!(:admin_role) { Fabricate(Group::VereinJodler::Admin.sti_name.to_sym, group: verein) }
        let!(:kassier_role) {
          Fabricate(Group::VereinJodler::Kassier.sti_name.to_sym, group: vorstand)
        }
        let!(:praesident_role) {
          Fabricate(Group::VereinJodler::Praesident.sti_name.to_sym, group: vorstand)
        }

        it "finds kassier role" do
          expect(subject).to eq(kassier_role)
        end
      end

      context "with kassier and praesident role" do
        let!(:kassier_role) {
          Fabricate(Group::VereinJodler::Kassier.sti_name.to_sym, group: vorstand)
        }
        let!(:praesident_role) {
          Fabricate(Group::VereinJodler::Praesident.sti_name.to_sym, group: vorstand)
        }

        xit "finds kassier role" do
          expect(subject).to eq(kassier_role)
        end
      end

      context "with admin and kassier role" do
        let!(:admin_role) { Fabricate(Group::VereinJodler::Admin.sti_name.to_sym, group: verein) }
        let!(:kassier_role) {
          Fabricate(Group::VereinJodler::Kassier.sti_name.to_sym, group: vorstand)
        }

        xit "finds kassier role" do
          expect(subject).to eq(kassier_role)
        end
      end

      context "with admin and praesident role" do
        let!(:admin_role) { Fabricate(Group::VereinJodler::Admin.sti_name.to_sym, group: verein) }
        let!(:praesident_role) {
          Fabricate(Group::VereinJodler::Praesident.sti_name.to_sym, group: vorstand)
        }

        it "finds praesident role" do
          expect(subject).to eq(praesident_role)
        end
      end
    end
  end

  describe "find_verein" do
    subject { InvoiceRuns::VereinMembershipFeeRecipientFinder.find_verein(recipient.id) }

    let!(:admin_role) { Fabricate(Group::VereinJodler::Admin.sti_name.to_sym, group: verein) }
    let!(:kassier_role) { Fabricate(Group::VereinJodler::Kassier.sti_name.to_sym, group: vorstand) }
    let!(:praesident_role) {
      Fabricate(Group::VereinJodler::Praesident.sti_name.to_sym, group: vorstand)
    }

    context "for admin role" do
      let(:recipient) { admin_role.person }

      it "finds verein" do
        expect(subject).to eq(verein)
      end
    end

    xcontext "for kassier role" do
      let(:recipient) { kassier_role.person }

      it "finds verein" do
        expect(subject).to eq(verein)
      end
    end

    context "for praesident role" do
      let(:recipient) { praesident_role.person }

      it "finds verein" do
        expect(subject).to eq(verein)
      end
    end
  end
end
