# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe JobsController do
  let(:jobs) do
    [
      RefreshActiveYearsJob,
      JodlerfestExportJob,
      SessionsCleanerJob
    ]
  end
  let(:admin) { people(:admin) }

  before do
    jobs.map(&:new).each(&:schedule)
    sign_in(admin)
  end

  context "#index" do
    it "lists only the managed jobs" do
      get :index

      expect(
        assigns(:jobs).map(&:handler).map do |marshalled_handler|
          marshalled_handler.sub(/\A.*:(\w*) {.*\z/m, '\1')
        end
      ).to match_array %w[
        JodlerfestExportJob
      ]
    end
  end
end
