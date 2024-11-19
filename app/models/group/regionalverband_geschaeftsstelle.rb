# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Group::RegionalverbandGeschaeftsstelle < Group
  class Manager < Role::GeschaeftsstelleManager
  end

  class Staff < Role::GeschaeftsstelleStaff
  end

  class Help < Role::GeschaeftsstelleHelp
  end

  self.default_role = Staff
  roles Manager, Staff, Help
end
