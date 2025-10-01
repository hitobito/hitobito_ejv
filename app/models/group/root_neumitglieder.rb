# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::RootNeumitglieder < ::Group
  self.static_name = true

  ### ROLES
  class Neuanmeldung < ::Role
    self.permissions = []
  end

  # make this read-only so nobody can disable self-registration on those groups
  def self_registration_role_type
    Group::RootNeumitglieder::Neuanmeldung.sti_name
  end

  roles Neuanmeldung
end
