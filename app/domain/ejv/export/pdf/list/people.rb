# frozen_string_literal: true

#  Copyright (c) 2012-2026, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv
  module Export::Pdf::List
    module People
      def name(person)
        person.full_name # person_name without nickname
      end
    end
  end
end
