# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require Rails.root.join("db", "seeds", "support", "group_seeder")

Group::Root.seed_once(:parent_id, name: "Eidgenössischer Jodlerverband")

root_id = Group.where(name: "Eidgenössischer Jodlerverband").pluck(:id).first

Group::Mitgliederverband.seed_once(:short_name, [
  {parent_id: root_id, short_name: "BKJV", name: "Bernisch Kantonaler Jodlerverband"},
  {parent_id: root_id, short_name: "NOSJV", name: "Nordostschweizerischer Jodlerverband"},
  {parent_id: root_id, short_name: "NWSJV", name: "Nordwestschweizerischer Jodlerverband"},
  {parent_id: root_id, short_name: "ZSJV", name: "Zentralschweizerischer Jodlerverband"},
  {parent_id: root_id, short_name: "WSJV", name: "Westschweizerischer Jodlerverband"},
  {parent_id: root_id, short_name: "EJV", name: "Ausländische Jodlerverbände"}
])

puts "Rebuilding nested set..."
Group.rebuild!(false)
puts "Moving Groups in alphabetical order..."
Group.find_each do |group|
  group.send(:move_to_alphabetic_position)
rescue => e
  puts e
  puts group
end
puts "Done."
