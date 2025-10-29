# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::Root < ::Group
  self.layer = true
  self.default_children = [
    Group::RootGeschaeftsstelle,
    Group::RootVorstand,
    Group::RootEinzelmitglieder,
    Group::RootNeumitglieder,
    Group::Kontakte
  ]

  self.event_types = [Event, Event::Course]

  children Group::RootGeschaeftsstelle,
    Group::RootVorstand,
    Group::RootDelegierte,
    Group::RootArbeitsgruppe,
    Group::RootEinzelmitglieder,
    Group::RootNeumitglieder,
    Group::Mitgliederverband

  ### ROLES

  class Admin < Role::Admin
    self.permissions = [
      :layer_and_below_full,
      :admin,
      :impersonation,
      :finance,
      :song_census
    ]
  end

  class SuisaAdmin < Role::SuisaAdmin
  end

  roles Admin, SuisaAdmin
end
