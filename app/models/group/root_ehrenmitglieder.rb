# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::RootEhrenmitglieder < Group
  children Group::RootEhrenmitglieder

  class Adressverwaltung < Role::Adressverwaltung
  end

  class Ehrenmitglied < Role::Ehrenmitglied
  end

  self.default_role = Ehrenmitglied
  roles Adressverwaltung, Ehrenmitglied
end
