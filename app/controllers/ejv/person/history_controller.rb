# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::Person::HistoryController
  def entry
    super
  rescue ActiveRecord::RecordNotFound => e
    if @group.is_a? Group::Root
      @person = Person.where(primary_group_id: nil).find(params[:id])
    else
      raise e
    end
  end
end
