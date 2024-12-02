# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

Fabricator(:festival, from: :event, class_name: :"Event::Festival") do
  name "Musikfestus"
  group_ids do
    [ActiveRecord::FixtureSet.identify(:root)]
  end
  application_opening_at { Date.current }
  application_closing_at { Date.current.advance(weeks: 1) }
end

Fabricator(:group_participation, class_name: :"Event::GroupParticipation") do
  event { Fabricate(:festival) }
end
