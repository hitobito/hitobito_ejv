# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# seemingly this is not autoloaded by bundler
require_dependency 'aasm'

# In the Event::GroupParticipation, there are two state-machines with an
# overlapping event-name. This triggers a warning which can be ignored in this
# case.
::AASM::Configuration.hide_warnings = true
