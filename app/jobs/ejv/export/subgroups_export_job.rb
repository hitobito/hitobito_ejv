# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::Export::SubgroupsExportJob
  def initialize(user_id, group_id, options)
    super
    @exporter = Export::Tabular::Groups::AddressList
  end

  private

  def entries
    super.where(type: types.map(&:sti_name))
  end

  def types
    [
      Group::Mitgliederverband,
      Group::Verein
    ]
  end
end
