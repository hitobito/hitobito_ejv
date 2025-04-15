# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::RolesHelper
  def group_options
    @group_selection.map do |group| # rubocop:disable Rails/HelperInstanceVariable
      [group.to_s, group.id]
    end
  end

  def default_language_for_person
    Settings.application.correspondence_languages.to_hash.invert.first
  end
end
