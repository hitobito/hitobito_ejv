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
    send_people_data
    # send_group_data # maybe
  end

  private

  def send_people_data
    cols = person_mapping.keys
    header = "INSERT INTO adressenstamm (#{cols.join(",")}) VALUES "
    footer = " ON DUPLICATE KEY UPDATE #{cols.map { |k| "#{k}=VALUES(#{k})" }.join(",")};"

    Person.in_batches(of: 500) do |batch|
      rows = []

      batch.find_each do |person|
        rows << "(#{person_values(person)})"
      end

      upsert = header + rows.join(", ") + footer
      @target.query(upsert)
    end
  end

  def person_values(person)
    person_mapping.map do |_, source|
      value = if source.respond_to? :call
        source.call(person)
      elsif source.is_a? Symbol
        person.send(source)
      else
        source
      end

      case value
      when String then @target.escape(value).inspect
      when Integer then value
      when ActiveSupport::TimeWithZone then value.strftime("%Y-%m-%d %H:%M").inspect
      when nil then "NULL"
      end
    end.join(",")
  end

  def person_mapping
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
      "AdrDatU" => :updated_at,
      "AdrWerbung" => 0,
      "AdrNews" => 0
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
end
