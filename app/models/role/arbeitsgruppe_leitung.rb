# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  group_id   :integer          not null
#  type       :string(255)      not null
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

#  Copyright (c) 2012-2024, Puzzle ITC GmbH. This file is part of
#  hitobito_generic and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_generic.

class Role::ArbeitsgruppeLeitung < Role
  self.permissions = [:group_and_below_full]
end
