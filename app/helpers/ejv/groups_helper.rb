# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::GroupsHelper
  def swappable_group_add_fieldset(*keys)
    title = t("person.history.history_members_form_ejv.text_with_alternative_link_html",
      text: t(".#{keys.last}"),
      link: link_to(t(".#{keys.first}"), "#", data: {swap: "group-fields"}))

    visible = keys.last == :select_existing_verein
    field_set_tag(title, class: "group-fields", style: element_visible(visible)) { yield }
  end

  def subverein_checkboxes(root)
    SubvereinCheckboxesBuilder.checkboxes(root, self)
  end
end
