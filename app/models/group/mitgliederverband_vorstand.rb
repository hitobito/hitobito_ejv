# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::MitgliederverbandVorstand < Group
  class Praesident < Role::VorstandPraesident
  end

  class VizePraesident < Role::VorstandVizePraesident
  end

  class Kassier < Role::VorstandKassier
  end

  class Mitgliederverwalter < Role::VorstandMitgliederverwalter
  end

  class Mitglied < Role::VorstandMitglied
  end

  class Sekretaer < ::Role
    self.permissions = [:group_full, :layer_and_below_read]
  end

  self.standard_role = Mitglied
  roles Praesident, VizePraesident, Kassier, Mitgliederverwalter, Sekretaer, Mitglied
end
