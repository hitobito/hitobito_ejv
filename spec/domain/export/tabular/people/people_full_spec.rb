# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Export::Tabular::People::PeopleFull do
  let(:person) { people(:leader) }
  let(:scope) { Person.where(id: person.id) }
  let(:people_list) { Export::Tabular::People::PeopleFull.new(scope) }

  subject { people_list }

  its(:attributes) do
    expected = [:id, :first_name, :last_name, :nickname, :company_name, :company, :email,
      :address_care_of, :street, :housenumber, :postbox, :zip_code, :town, :country,
      :layer_group, :roles, :gender, :birthday, :additional_information, :language,
      :profession, :active_years, :active_role, :personal_data_usage, :tags]
    should match_array expected
    should eq expected
  end
end
