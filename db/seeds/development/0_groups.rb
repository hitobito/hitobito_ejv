# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.


require Rails.root.join('db', 'seeds', 'support', 'group_seeder')

Group::Root.seed_once(:parent_id, name: 'EJV')

# BESETZUNGEN_MEMO = { 'bb' => 'brass_band',
#                      'h' => 'harmonie',
#                      'f/b' => 'fanfare_benelux',
#                      't/p' => 'fanfare_mixte' }.freeze

# seeder = GroupSeeder.new
# root = Group::Root.order(:id).first
# srand(42)
#
# require 'csv'
#
# def limited(collection, selection: nil, limit: nil)
#   return collection unless Rails.env.development?
#   collection = collection & selection if selection
#   collection = collection.take(limit) if limit
#   collection
# end
#
# def build_verein_attrs(parent_id, name, besetzung, lang)
#   attrs = { name: name, parent_id: parent_id,
#     address: Faker::Address.street_address,
#     zip_code: Faker::Address.zip[0..3],
#     town: Faker::Address.city,
#     correspondence_language: lang,
#   }
#
#   if besetzung
#     attrs.merge({
#       besetzung: BESETZUNGEN_MEMO.fetch(besetzung, nil),
#     })
#   end
#
#   attrs
# end
