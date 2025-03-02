# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::Event
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    self.used_attributes += [:waiting_list]

    register_role_type(::Event::Role::JuryMitglied)
  end
end
