# frozen_string_literal: true

#  Copyright (c) 2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::MitgliederverbandVereinigung < Group
  class Praesident < Role
    self.permissions = [:group_and_below_full]
  end

  class Mitglied < Role
  end

  self.default_role = Mitglied
  roles Praesident, Mitglied
end
