# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Groups::SelfRegistrationController do
  let(:group) { groups(:neumitglieder) }

  def wizard_params(step: 0, **attrs)
    {
      group_id: group.id,
      step: step
    }.merge(wizards_signup_root_neumitglieder_wizard: attrs)
  end

  describe "completing wizard" do
    let(:required_params) {
      wizard_params(
        main_email_field: {
          email: "max.muster@example.com"
        },
        person_fields: {
          gender: "m",
          first_name: "Max",
          last_name: "Muster",
          street: "Musterplatz",
          housenumber: "42",
          postbox: "Postfach 23",
          town: "Zurich",
          zip_code: "8000",
          birthday: "1.1.2000",
          country: "CH",
          language: "de",
          phone_number: "+41 79 123 45 67",
          verband: "EJV",
          sparte: "Jodlerverein",
          group: "Noch keine"
        }
      )
    }

    context "anonymous" do
      it "redirects to login" do
        post :create, params: required_params.merge(step: 1)

        expect(response).to redirect_to new_person_session_path
        # rubocop:todo Layout/LineLength
        expect(flash[:notice]).to eq "Du hast Dich erfolgreich registriert. Du erhältst in Kürze eine E-Mail mit der Anleitung, wie Du Deinen Account freischalten kannst."
        # rubocop:enable Layout/LineLength
      end
    end

    context "when logged in" do
      let(:user) { people(:conductor) }

      before { sign_in(user) }

      it "redirects to dashboard" do
        post :create, params: required_params.merge(step: 1)

        expect(user.groups).to include groups(:neumitglieder)
        expect(response).to redirect_to dashboard_path
        # rubocop:todo Layout/LineLength
        expect(flash[:notice]).to eq "Deine Anmeldung wurde erfolgreich verschickt. Wir melden uns in Kürze bei dir."
        # rubocop:enable Layout/LineLength
      end
    end
  end

  context "with existing email" do
    let(:admin) { people(:admin) }

    it "redirects to login page" do
      post :create, params: wizard_params(main_email_field: {email: admin.email})

      # rubocop:todo Layout/LineLength
      expect(response).to redirect_to(new_person_session_path(person: {login_identity: admin.email}))
      # rubocop:enable Layout/LineLength
      # rubocop:todo Layout/LineLength
      expect(flash[:notice]).to eq "Es existiert bereits ein Login für diese E-Mail. Melde dich hier an."
      # rubocop:enable Layout/LineLength
    end
  end
end
