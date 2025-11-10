# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class JobsController < CrudController
  skip_authorize_resource
  before_action :authorize_class

  MANAGED_JOBS = [
    # RefreshActiveYearsJob,
    JodlerfestExportJob
  ]

  def run
    updated = with_callbacks(:update, :save) { entry.update(run_at: 1.second.ago) }
    respond_with(entry, success: updated, location: jobs_path)
  end

  def self.model_class
    Delayed::Job
  end

  def list_entries
    managed_jobs.inject(model_class.none) do |scope, job_name|
      scope.or(model_class.where("handler LIKE ?", "%#{job_name}%"))
    end
  end

  def managed_jobs
    MANAGED_JOBS.map(&:name)
  end
end
