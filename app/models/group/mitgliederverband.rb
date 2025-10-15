# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# == Schema Information
#
# Table name: groups
#
#  id                          :integer          not null, primary key
#  parent_id                   :integer
#  lft                         :integer
#  rgt                         :integer
#  name                        :string(255)      not null
#  short_name                  :string(31)
#  type                        :string(255)      not null
#  email                       :string(255)
#  address                     :string(1024)
#  zip_code                    :integer
#  town                        :string(255)
#  country                     :string(255)
#  contact_id                  :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  deleted_at                  :datetime
#  layer_group_id              :integer
#  creator_id                  :integer
#  updater_id                  :integer
#  deleter_id                  :integer
#  require_person_add_requests :boolean          default(FALSE), not null
#  vereinssitz                 :string(255)
#  association_entry               :integer
#  swoffice_id                 :integer
#  description                 :text(65535)
#  logo                        :string(255)
#

class Group::Mitgliederverband < ::Group
  self.layer = true
  self.default_children = [
    Group::MitgliederverbandVorstand,
    Group::MitgliederverbandEinzelmitglieder,
    Group::MitgliederverbandNachwuchsmitglieder
  ]

  self.event_types += [Event::Course]

  children Group::MitgliederverbandVorstand,
    Group::MitgliederverbandEinzelmitglieder,
    Group::MitgliederverbandNachwuchsmitglieder,
    Group::VereinJodler,
    Group::VereinJodlerNachwuchs,
    Group::VereinAlphornblaeser,
    Group::VereinAlphornblaeserNachwuchs,
    Group::VereinFahnenschwinger,
    Group::VereinFahnenschwingerNachwuchs

  ### ROLES

  class Admin < Role::Admin
    self.permissions = [:layer_and_below_full]
  end

  class SuisaAdmin < Role::SuisaAdmin
  end

  roles Admin, SuisaAdmin
end
