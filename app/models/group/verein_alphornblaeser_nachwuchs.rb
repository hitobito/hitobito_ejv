# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::VereinAlphornblaeserNachwuchs < Group::Verein
  def suisa_admins
    Person.joins(:roles)
      .where("roles.type = 'Group::VereinAlphornblaeserNachwuchs::SuisaAdmin' " \
             "AND roles.group_id = #{id}")
  end

  ### ROLES

  class Admin < Role::Admin
    self.permissions = [:layer_and_below_full]
  end

  class Conductor < Role
    self.permissions = []
  end

  class SuisaAdmin < Role::SuisaAdmin
  end

  class Mitglied < Role::MitgliederMitglied
    self.permissions = [:group_read]
  end

  class Praesident < Role::VorstandPraesident
  end

  class Kassier < Role::VorstandKassier
  end

  roles Admin, Conductor, SuisaAdmin, Mitglied, Praesident, Kassier
end
