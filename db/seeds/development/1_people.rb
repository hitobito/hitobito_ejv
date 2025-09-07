# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require Rails.root.join("db", "seeds", "support", "person_seeder")

class EjvPersonSeeder < PersonSeeder
  def amount(role_type)
    case role_type.name
    when "Group::VereinJodler::Mitglied" then Rails.env.development? ? 4 : 20
    else 1
    end
  end
end

puzzlers = [
  "Andreas Maierhofer",
  "Daniel Illi",
  "Matthias Viehweger",
  "Niklas Jaeggi",
  "Nils Rauch",
  "Pascal Zumkehr"
]

devs = {}

puzzlers.each do |puz|
  devs[puz] = "#{puz.split.last.downcase}@puzzle.ch"
end

seeder = EjvPersonSeeder.new

seeder.seed_all_roles

root = Group::Root.first

devs.each do |name, email|
  seeder.seed_developer(name, email, root, Group::Root::Admin)
end

seeder.assign_role_to_root(root, Group::Root::Admin)
