# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::Mitgliederverband < ::Group
  self.layer = true
  self.default_children = [
    Group::MitgliederverbandVorstand,
    Group::MitgliederverbandEinzelmitglieder,
    Group::MitgliederverbandNachwuchsmitglieder,
    Group::Kontakte
  ]

  self.event_types += [Event::Course]

  children Group::MitgliederverbandVorstand,
    Group::MitgliederverbandEinzelmitglieder,
    Group::MitgliederverbandNachwuchsmitglieder,
    Group::VereinJodler,
    Group::VereinJodlerNachwuchs,
    Group::VereinAlphornblaeser,
    Group::VereinAlphornblaeserNachwuchs,
    Group::VereinFahnenschwinger,
    Group::VereinFahnenschwingerNachwuchs

  ### ROLES

  class Admin < Role::Admin
    self.permissions = [:layer_and_below_full]
  end

  class SuisaAdmin < Role::SuisaAdmin
  end

  roles Admin, SuisaAdmin
end
