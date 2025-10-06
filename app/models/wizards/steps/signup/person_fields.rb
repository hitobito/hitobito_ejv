# frozen_string_literal: true

#  https://github.com/hitobito/hitobito_sac_cas.
#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Wizards::Steps::Signup::PersonFields < Wizards::Step
  include I18nEnums

  PHONE_NUMBER_LABEL = "mobile"

  i18n_enum :gender, Person::GENDERS + [I18nEnums::NIL_KEY], i18n_prefix: "activerecord.attributes.person.genders"

  attribute :id, :integer # for when dealing with persisted users

  attribute :gender, :string
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :birthday, :date
  attribute :email, :string
  attribute :address_care_of, :string
  attribute :street, :string
  attribute :housenumber, :string

  attribute :postbox, :string
  attribute :zip_code, :string
  attribute :town, :string
  attribute :country, :string
  attribute :phone_number, :string
  attribute :correspondence_language, :string
  attribute :verband, :string
  attribute :sparte, :string
  attribute :group, :string

  validates :gender, :first_name, :last_name, :birthday, :street, :housenumber, :town, :zip_code,
    :country, :correspondence_language, :verband, :sparte, :phone_number, presence: true

  validates :zip_code, zipcode: {country_code_attribute: :country}

  validate :assert_valid_phone_number

  def self.human_attribute_name(attr, options = {})
    super(attr, default: Person.human_attribute_name(attr, options))
  end

  def self.verbaende
    ["EJV", "BKJV", "ZSJV", "NOSJV", "NWSJV", "WSJV"]
  end

  def self.sparten
    human_attribute_name(:sparten).split(", ")
  end

  def initialize(...)
    super

    if current_user
      self.id = current_user.id
      self.gender ||= current_user.gender.presence || I18nEnums::NIL_KEY
      self.first_name ||= current_user.first_name
      self.last_name ||= current_user.last_name
      self.birthday ||= current_user.birthday
      self.email ||= current_user.email
      self.address_care_of ||= current_user.address_care_of
      self.street ||= current_user.street
      self.housenumber ||= current_user.housenumber
      self.postbox ||= current_user.postbox
      self.zip_code ||= current_user.zip_code
      self.town ||= current_user.town
      self.country ||= current_user.country
      self.phone_number ||= current_user.phone_numbers.find_by(label: PHONE_NUMBER_LABEL)&.number
    else
      self.country ||= Settings.addresses.imported_countries.to_a.first
    end
  end

  def person_attributes
    attributes.compact.symbolize_keys.except(:phone_number).then do |attrs|
      attrs = build_additional_information(attrs)
      attrs[:gender] = nil if attrs[:gender] == I18nEnums::NIL_KEY

      next attrs if phone_number.blank?
      attrs.merge(phone_numbers_attributes: {number: phone_number, label: PHONE_NUMBER_LABEL, id: phone_number_id})
    end
  end

  def correspondence_languages
    Settings.application.correspondence_languages.to_a
  end

  private

  def build_additional_information(attrs)
    relevant_attributes = [:sparte, :verband, :group]

    additional_information = relevant_attributes.map do |relevant_attribute|
      value = attrs.fetch(relevant_attribute, nil)
      label = self.class.human_attribute_name(relevant_attribute)
      next if value.blank?

      "#{label}: #{value}"
    end.compact.join("\n")

    attrs.except(*relevant_attributes)
      .merge(additional_information: additional_information)
  end

  def assert_is_valid_swiss_post_code
    if zip_code.present? && Countries.swiss?(country) && !zip_code.to_s.match(/\A\d{4}\z/)
      errors.add(:zip_code)
    end
  end

  def phone_number_id
    PhoneNumber.find_by(label: PHONE_NUMBER_LABEL, contactable_id: id, contactable_type: Person.sti_name)&.id if id
  end

  def assert_valid_phone_number
    if phone_number.present? && PhoneNumber.new(number: phone_number).tap(&:valid?).errors.key?(:number)
      errors.add(:phone_number, :invalid)
    end
  end
end
