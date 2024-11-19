# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


class AddActiveYearsToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :active_years, :integer
    add_column :people, :active_role, :boolean, default: false, null: false
    Person.reset_column_information
    reversible do |dir|
      dir.up do
        say_with_time("Calculating active years") do
          end_date = Time.zone.now

          Person.find_each do |person|
            active_years = person.roles.with_deleted.where("type LIKE '%Mitglied'").map do |role|
              VeteranYears.new(role.created_at.year, (role.deleted_at || end_date).year)
            end.sort.sum.years.to_i
            active_roles = person.roles.where("type LIKE '%Mitglied'").any?

            person.active_years = active_years
            person.active_role  = active_roles
            person.save(validate: false)
          end
        end
      end
    end
  end
end
