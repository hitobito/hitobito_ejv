# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class JodlerfestExportJob < RecurringJob
  run_every 1.day

  private

  def perform_internal
    db_url = ENV["JODLER_DB_URL"] # rubocop:disable Rails/EnvironmentVariableAccess
    return if db_url.blank?

    client = JodlerDb.new(db_url).connect
    JodlerfestExport.new(client).run
  end
end
