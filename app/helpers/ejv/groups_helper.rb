# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::GroupsHelper
  def mitglieder_group_as_select_options
    Group::Verein::VereinMitglieder
      .with_deleted.includes(:parent)
      .where.not(parent: Group::Verein.hidden)
      .collect do |g|
        next unless g.parent

        [g.parent.name, g.id]
      end.compact.sort_by(&:first)
  end

  def swappable_group_add_fieldset(*keys)
    title = t("person.history.history_members_form_ejv.text_with_alternative_link_html",
      text: t(".#{keys.last}"),
      link: link_to(t(".#{keys.first}"), "#", data: {swap: "group-fields"}))

    visible = keys.last == :select_existing_verein
    field_set_tag(title, class: "group-fields", style: element_visible(visible)) { yield }
  end

  def format_correspondence_language(verein)
    Settings.application.correspondence_languages
      .to_h.stringify_keys[verein.correspondence_language.to_s]
  end

  def format_unterhaltungsmusik(verein)
    verein.unterhaltungsmusik_label
  end

  def format_klasse(verein)
    verein.klasse_label
  end

  def format_besetzung(verein)
    verein.besetzung_label
  end

  def subverein_checkboxes(root)
    SubvereinCheckboxesBuilder.checkboxes(root, self)
  end
end
