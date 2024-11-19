# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Sheet
  module Events
    class GroupParticipation < Base
      self.parent_sheet = Sheet::Event

      delegate :t, to: :I18n

      def title
        t("events.group_participations.actions_new.title")
      end
    end
  end
end
