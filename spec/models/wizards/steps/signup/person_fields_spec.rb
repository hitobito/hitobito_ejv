#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Wizards::Steps::Signup::PersonFields do
  let(:wizard) { instance_double(Wizards::Signup::RootNeumitgliederWizard, current_user: nil) }

  subject(:form) { described_class.new(wizard) }

  let(:required_attrs) {
    {
      gender: "m",
      first_name: "Max",
      last_name: "Mustermann",
      birthday: 42.years.ago,
      street: "Musterplatz",
      housenumber: "23",
      town: "Zurich",
      zip_code: "8000",
      country: "CH",
      language: "de",
      verband: "EJV",
      sparte: "Jodeln",
      phone_number: "079 123 34 56"
    }
  }

  describe "::human_attribute_name" do
    it "reads from person" do
      expect(described_class.human_attribute_name(:first_name)).to eq "Vorname"
    end
  end

  describe "validations" do
    it "is valid if required attrs are set" do
      form.attributes = required_attrs

      form.valid?

      expect(form.errors.map(&:full_message)).to eq []
      expect(form).to be_valid
    end

    it "validates presence of each required attr" do
      expect(form).not_to be_valid
      required_attrs.except(:country).keys.each do |attr|
        expect(form.errors.attribute_names).to include(attr)
      end
    end

    describe "gender" do
      it "accepts _nil gender" do
        form.attributes = required_attrs.merge(gender: "_nil")
        expect(form).to be_valid
        expect(form.gender_label).to eq "divers"
      end
    end

    describe "phone_number" do
      it "must be have a valid format" do
        form.phone_number = "test"
        expect(form).not_to be_valid
        expect(form.errors[:phone_number]).to eq ["ist nicht gültig"]
      end
    end

    describe "zip_code" do
      it "validates swiss zip code format" do
        form.attributes = required_attrs.merge(zip_code: "123")
        expect(form).not_to be_valid
        expect(form.errors.full_messages).to eq ["PLZ ist nicht gültig"]
      end

      it "validates other zip code formats" do
        form.attributes = required_attrs.merge(zip_code: "123", country: "US")
        expect(form).not_to be_valid
        expect(form.errors.full_messages).to eq ["PLZ ist nicht gültig"]
        form.zip_code = 90210
        expect(form).to be_valid
      end
    end
  end

  it "sets country default to ch" do
    expect(form.country).to eq "CH"
  end

  it "does not requires_policy_acceptance?" do
    expect(form.country).to eq "CH"
  end

  describe "#person_attributes" do
    it "builds with nested phone_number attributes" do
      form.attributes = required_attrs

      expect(form.person_attributes[:phone_number]).to eq nil
      expect(form.person_attributes[:phone_numbers_attributes]).to eq({
        number: required_attrs[:phone_number], label: "mobile", id: nil
      })
    end

    it "converts gender value of '_nil' to nil" do
      form.attributes = required_attrs.merge(gender: "_nil")

      expect(form.person_attributes[:gender]).to be_nil
    end

    it "joins additional_information" do
      form.attributes = required_attrs.merge(group: "Noch keiner")

      # rubocop:todo Layout/LineLength
      expect(form.person_attributes[:additional_information]).to eq "Beitritt zu welcher Sparte?: Jodeln
Beitritt zu welchem Verband?: EJV
Welcher Gruppe gehörst du an?: Noch keiner"
      # rubocop:enable Layout/LineLength
    end
  end

  describe "sparten" do
    it "reads sparten from locales" do
      expect(described_class.sparten).to eq ["Jodeln", "Alphornblasen", "Fahnenschwingen",
        "Freund&Gönner"]
    end
  end

  context "with current user" do
    let(:params) { {} }
    let(:person) { people(:conductor) }
    let(:wizard) { instance_double(Wizards::Signup::RootNeumitgliederWizard, current_user: person) }

    subject(:form) { described_class.new(wizard, **params) }

    it "reads attributes from current_user" do
      person.attributes = {country: "CH", postbox: "12"}
      expect(form.id).to eq person.id
      expect(form.gender).to eq "m"
      expect(form.first_name).to eq "Dieter"
      expect(form.last_name).to eq "Irigent"
      expect(form.birthday).to eq Date.new(1970, 8, 14)
      expect(form.street).to eq "Ophovenerstrasse"
      expect(form.housenumber).to eq "79a"
      expect(form.postbox).to eq "12"
      expect(form.zip_code).to eq "8634"
      expect(form.town).to eq "Hombrechtikon"
      expect(form.country).to eq "CH"
      expect(form.phone_number).to be_blank
    end

    it "reads nil gender into I18nEnum::NIL_KEY" do
      person.gender = nil
      expect(form.gender).to eq "_nil"
    end

    it "reads phone_number if present" do
      number = person.phone_numbers.create!(label: "mobile", number: "0791234567")
      expect(form.phone_number).to eq "+41 79 123 45 67"
      expect(form.person_attributes[:phone_numbers_attributes][:id]).to eq number.id
    end

    it "params override values read from person" do
      params[:first_name] = "Test"
      expect(form.first_name).to eq "Test"
      expect(form.last_name).to eq "Irigent"
    end
  end
end
