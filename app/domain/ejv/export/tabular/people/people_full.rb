# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv
  module Export
    module Tabular
      module People
        module PeopleFull
          extend ActiveSupport::Concern

          included do
            alias_method_chain :person_attributes, :active_years
          end

          def person_attributes_with_active_years
            person_attributes_without_active_years + [:active_years]
          end
        end
      end
    end
  end
end
