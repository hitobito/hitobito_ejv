# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::RecurringJob
  extend ActiveSupport::Concern

  def description
    I18n.t(:description, scope: "jobs.#{self.class.name.underscore}")
  end
end
