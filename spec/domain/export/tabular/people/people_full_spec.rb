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
      :profession, :active_years, :active_role, :personal_data_usage, :tags,
      :additional_email_privat, :additional_email_arbeit, :additional_email_vater,
      :additional_email_mutter, :additional_email_andere, :additional_email_free_text,
      :phone_number_privat, :phone_number_mobil, :phone_number_arbeit, :phone_number_vater,
      :phone_number_mutter, :phone_number_fax, :phone_number_andere, :social_account_facebook,
      :social_account_msn, :social_account_skype, :social_account_twitter,
      :social_account_webseite, :social_account_andere, :social_account_free_text,
      :additional_address_rechnung, :additional_address_arbeit, :additional_address_andere,
      :additional_address_free_text]
    should match_array expected
    should eq expected
  end
end
