#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe :self_registration do
  let(:group) { groups(:neumitglieder) }

  it "is possible to self registrate" do
    visit group_self_registration_path(group_id: group.id)

    fill_in "Email", with: "max.mustermann@puzzle.ch"
    click_button "Weiter"

    choose("männlich")
    fill_in "Vorname", with: "Max"
    fill_in "Nachname", with: "Mustermann"
    fill_in "Geburtstag", with: "19.01.1991"
    fill_in "Adresse", with: "Brauereistrasse"
    fill_in "wizards_signup_root_neumitglieder_wizard_person_fields_housenumber", with: "1"
    fill_in "wizards_signup_root_neumitglieder_wizard_person_fields_zip_code", with: "8634"
    fill_in "wizards_signup_root_neumitglieder_wizard_person_fields_town", with: "Entenhausen"
    select "Schweiz", from: "wizards_signup_root_neumitglieder_wizard_person_fields_country", match: :first
    fill_in "Telefon", with: "079 123 45 67"
    select "Deutsch", from: "Sprache"
    select "EJV", from: "Beitritt zu welchem Verband?"
    select "Jodeln", from: "Beitritt zu welcher Sparte?"
    fill_in "Welcher Gruppe gehörst du an?", with: "Bis jetzt keiner"
    click_button "Absenden"

    expect(page).to have_text "Du hast Dich erfolgreich registriert."
  end
end
