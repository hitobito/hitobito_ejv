# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::GroupAbility
  extend ActiveSupport::Concern

  included do
    on(Group) do
      permission(:any).may(:query).all
      permission(:any).may(:deleted_subgroups).if_writable

      permission(:group_full).may(:create_history_member).in_same_group
      permission(:group_and_below_full).may(:create_history_member).in_same_group_or_below
      permission(:layer_full).may(:create_history_member).in_same_layer
      permission(:layer_and_below_full).may(:create_history_member).in_same_layer_or_below

      permission(:finance).may(:subverein_select).in_layer_group
    end
  end

  def if_writable
    [
      :layer_and_below_full,
      :layer_full,
      :group_and_below_full,
      :group_full
    ].any? do |permission|
      user_context.permission_group_ids(permission).include?(group.id)
    end
  end
end
