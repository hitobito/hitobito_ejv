# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv
  module Export
    module Tabular
      module Groups
        module List
          extend ActiveSupport::Concern

          def attributes
            super + [:recognized_members]
          end
        end
      end
    end
  end
end
