# frozen_string_literal: true

#  Copyright (c) 2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::RootDelegierte < ::Group
  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  self.standard_role = Mitglied
  roles Mitglied
end
