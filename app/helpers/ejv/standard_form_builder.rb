# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# rubocop:disable Rails/HelperInstanceVariable This is part of a class, not a helper per se
module Ejv::StandardFormBuilder
  def group_field(attr, html_options = {})
    _attr, attr_id = assoc_and_id_attr(attr)
    hidden_field(attr_id) +
      string_field(attr, # "#{attr}_search",
        placeholder: I18n.t("global.search.placeholder_group"),
        name: "group_name_search_result",
        data: {provide: "entity",
               id_field: "#{object_name}_#{attr_id}",
               url: @template.query_groups_path(html_options[:search_params])})
  end

  def labeled_gender_inline_radio_buttons
    radios = (Person::GENDERS + [I18nEnums::NIL_KEY]).map do |key|
      inline_radio_button(:gender, key, Person.new(gender: key).gender_label)
    end

    labeled(:gender, safe_join(radios))
  end
end
# rubocop:enable Rails/HelperInstanceVariable
