# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Export::GroupParticipationsExportJob < Export::ExportBaseJob
  self.parameters = PARAMETERS + [:festival_id]

  def initialize(format, user_id, festival_id, options)
    super(format, user_id, options)
    @exporter = Export::Tabular::GroupParticipations::List
    @festival_id = festival_id
  end

  def entries
    Event::GroupParticipation
      .where(event_id: @festival_id)
      .includes(:group, :secondary_group)
      .includes(group: [:contact])
  end
end
