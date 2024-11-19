# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::Root < ::Group
  self.layer = true
  self.default_children = [Group::RootGeschaeftsstelle,
    Group::RootVorstand,
    Group::RootMusikkommission,
    Group::RootKontakte,
    Group::RootEhrenmitglieder,
    Group::RootVeteranen]

  self.event_types = [Event, Event::Course, Event::Festival]

  children Group::RootGeschaeftsstelle,
    Group::RootVorstand,
    Group::RootMusikkommission,
    Group::RootArbeitsgruppe,
    Group::RootKontakte,
    Group::RootEhrenmitglieder,
    Group::RootVeteranen,
    Group::Mitgliederverband,
    Group::Verein

  ### ROLES

  class Admin < Role::Admin
    self.permissions = [
      :layer_and_below_full,
      :admin,
      :impersonation,
      :finance,
      :song_census,
      :uv_lohnsumme
    ]
  end

  class SuisaAdmin < Role::SuisaAdmin
  end

  roles Admin, SuisaAdmin
end
