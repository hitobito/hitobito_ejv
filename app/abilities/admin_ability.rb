# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class AdminAbility < AbilityDsl::Base
  on(Delayed::Job) do
    class_side(:index).if_admin

    permission(:admin).may(:run).if_root_admin
  end

  def if_root_admin
    if_admin && user_context.permission_group_ids(:any).include?(::Group.root.id)
  end
end
