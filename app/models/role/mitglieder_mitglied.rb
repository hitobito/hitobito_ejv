# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  group_id   :integer          not null
#  type       :string(255)      not null
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Role::MitgliederMitglied < Role
  self.permissions = [:layer_read]

  after_destroy :update_active_years_on_person
  after_save :update_active_years_on_person

  validates_date :start_on,
    allow_nil: true

  private

  def update_active_years_on_person
    person.cache_active_years
    person.save(validate: false)
  end
end
