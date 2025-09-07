# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class InvoiceLists::VereinMembershipFeeRecipientFinder
  def self.find_recipient(verein_id)
    vorstand_id = Group::VereinJodler.find_by(id: verein_id)&.id
    admin_role = Group::VereinJodler::Admin.find_by(group_id: verein_id)

    return admin_role if vorstand_id.blank?

    # Group::VereinJodler::Kassier.find_by(group_id: vorstand_id) ||
    Group::VereinJodler::Praesident.find_by(group_id: vorstand_id) ||
      admin_role
  end

  def self.find_verein(recipient_id)
    # Group::VereinJodler::Kassier.find_by(person_id: recipient_id) ||
    recipient_role = Group::VereinJodler::Praesident.find_by(person_id: recipient_id) ||
      Group::VereinJodler::Admin.find_by(person_id: recipient_id)

    recipient_role.group.layer_group
  end
end
