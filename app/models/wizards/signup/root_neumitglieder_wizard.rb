# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Wizards::Signup
  class RootNeumitgliederWizard < Wizards::RegisterNewUserWizard
    self.steps = [
      Wizards::Steps::Signup::MainEmailField,
      Wizards::Steps::Signup::PersonFields
    ]

    public :group

    private

    def build_person
      super do |person, role|
        person.gender = nil if person.gender == I18nEnums::NIL_KEY

        yield person, role if block_given?
      end
    end

    def person_attributes
      person_fields.person_attributes.merge(email:)
    end
  end
end
