# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::MitgliederverbandArbeitsgruppe < Group
  children Group::MitgliederverbandArbeitsgruppe

  class Leitung < Role::ArbeitsgruppeLeitung
  end

  class Mitglied < Role::ArbeitsgruppeMitglied
  end

  self.default_role = Mitglied
  roles Leitung, Mitglied
end
