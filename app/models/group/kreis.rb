# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::Kreis < ::Group
  self.layer = true
  self.default_children = [Group::KreisGeschaeftsstelle,
    Group::KreisVorstand,
    Group::KreisKontakte,
    Group::KreisMusikkommission]

  children Group::KreisGeschaeftsstelle,
    Group::KreisVorstand,
    Group::KreisMusikkommission,
    Group::KreisKontakte,
    Group::Verein

  ### ROLES

  class Admin < Role::Admin
    self.permissions = [:layer_and_below_full]
  end

  class SuisaAdmin < Role::SuisaAdmin
  end

  roles Admin, SuisaAdmin
end
