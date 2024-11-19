# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::RootKontakte < Group
  children Group::RootKontakte

  class Adressverwaltung < Role::Adressverwaltung
  end

  class Kontakt < Role::Kontakt
  end

  self.default_role = Kontakt
  roles Adressverwaltung, Kontakt
end
