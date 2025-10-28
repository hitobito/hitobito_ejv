# frozen_string_literal: true

#  Copyright (c) 2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::MitgliederverbandEinzelmitglieder < Group
  class Jodler < Role
  end

  class Alphornblaeser < Role
  end

  class Fahnenschwinger < Role
  end

  class Freund < Role
  end

  class Ehrenmitglied < Role
  end

  class Freimitglied < Role
  end

  class Veteran < Role
  end

  class EhrenVeteran < Role
  end

  self.standard_role = Jodler
  roles Jodler, Alphornblaeser, Fahnenschwinger, Freund, Ehrenmitglied, Freimitglied, Veteran,
    EhrenVeteran
end
