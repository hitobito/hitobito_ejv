# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv
  module Export
    module Tabular
      module Groups
        module Row
          extend ActiveSupport::Concern

          def initialize(entry, suisa_verein_statuses, format = nil)
            @suisa_verein_statuses = suisa_verein_statuses
            super(entry, format)
          end

          def contact_email
            entry.contact&.email
          end

          def suisa_status
            if entry.is_a?(::Group::Verein)
              translated_suisa_status(entry)
            end
          end

          private

          def translated_label(method)
            method = "#{method}_label" if entry.is_a?(::Group::Verein)
            entry.send(method)
          end

          def translated_suisa_status(verein)
            reason = @suisa_verein_statuses[verein.id]
            reason ||= "not_submitted"
            I18n.t("song_censuses.totals.#{reason}")
          end
        end
      end
    end
  end
end
