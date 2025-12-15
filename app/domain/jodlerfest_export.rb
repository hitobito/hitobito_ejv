# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class JodlerfestExport
  def initialize(target_db_client)
    @target = target_db_client
  end

  def run
    send_data("adressenstamm", person_mapping, Person)
    # send_data("gruppen", group_mapping, Group)
  end

  private

  def send_data(table, mapping, scope)
    cols = mapping.keys
    header = "INSERT INTO #{table} (#{cols.join(",")}) VALUES "
    footer = " ON DUPLICATE KEY UPDATE #{cols.map { |k| "#{k}=VALUES(#{k})" }.join(",")};"

    scope.in_batches(of: 500) do |batch|
      rows = []

      batch.find_each do |model|
        rows << "(#{data_values(model, mapping)})"
      end

      upsert = header + rows.join(", ") + footer
      @target.query(upsert)
    end
  end

  def data_values(model, mapping)
    data_map(model, mapping).values.join(",")
  end

  def data_map(model, mapping)
    mapping.map do |key, source|
      value = model_value(model, source).then { |val| cast_value(val) }

      [key, value]
    end.to_h
  end

  def model_value(model, value)
    if source.respond_to? :call
      source.call(model)
    elsif source.is_a? Symbol
      model.send(source)
    else
      source
    end
  end

  def cast_value(value)
    case value
    when String then @target.escape(value).inspect
    when Integer then value
    when ActiveSupport::TimeWithZone then value.strftime("%Y-%m-%d %H:%M").inspect
    when Date then value.strftime("%Y-%m-%d").inspect
    when TrueClass then "b'1'"
    when FalseClass then "b'0'"
    when nil then "NULL"
    end
  end

  def person_mapping # rubocop:disable Metrics/MethodLength
    @person_mapping ||= {
      "AdrNr" => :id,
      "AdrVorname" => :first_name,
      "AdrNameZ1" => :last_name,
      "AdrNameZ2" => :address_care_of,
      "AdrStrasse" => ->(p) { [p.street, p.housenumber].compact.join(" ") },
      "AdrPostfach" => :postbox,
      "AdrPlz" => :zip_code,
      "AdrOrt" => :town,
      "AdrLand" => :country,
      "AdrMail" => :email,
      "AdrSprache" => ->(p) { lang_mapping[p.language] },
      "AdrSex" => ->(p) { gender_mapping[p.gender] },
      "AdrTelM" => ->(p) { p.phone_numbers&.first&.number },
      "AdrGeburtsdatum" => :birthday,
      "AdrUv" => ->(p) { lookup_unterverband(p) },
      "AdrEinzelmitglied" => ->(p) { lookup_einzelmitglied(p) },
      "AdrNachwuchs" => ->(p) { lookup_nachwuchs(p) },
      "AdrDatU" => :updated_at,
      "AdrWerbung" => 0,
      "AdrNews" => 0
    }
  end

  def group_mapping
    @group_mapping ||= {
      "GruAdrNr" => :id,
      "GruMail" => :email,
      "GruName" => :name,
      "GruOrt" => :vereinssitz
      # "GruAdrNrPraesident" =>
      # "GruAdrNrDirigent" =>
      # "GruUV" =>
      # "GruTyp" =>
    }
  end

  def gender_mapping
    @gender_mapping ||= {
      nil => 1,
      "m" => 2,
      "w" => 3
    }
  end

  def lang_mapping
    @lang_mapping ||= {
      "de" => 1,
      "fr" => 2,
      "it" => 3,
      "en" => 4
    }
  end

  def lookup_unterverband(person)
    person.roles
      .where("type LIKE '%Mitglied'")
      .map(&:group).compact
      .map(&:parent).compact
      .map(&:short_name).compact
      .first
  end

  def lookup_einzelmitglied(person)
    person.roles.where("type LIKE '%Einzelmitglieder%'").exists?
  end

  def lookup_nachwuchs(person)
    person.roles.where("type LIKE '%Nachwuchsmitglieder%'").exists?
  end
end
