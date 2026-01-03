# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class JodlerfestExport # rubocop:disable Metrics/ClassLength
  def initialize(target_db_client)
    @target = target_db_client

    @schema_limits = {}
  end

  def run
    send_data("adressenstamm", person_mapping, Person)
    send_data("gruppen", group_mapping, Group)
    send_data("adressenstamm", group_addresses_mapping, Group)
    send_data("gruppenmitglieder", role_mapping, Role.where(type: relevant_role_types))
  end

  private

  # technical steps to transform our DB-Data into MySQL-Updates

  def send_data(table, mapping, scope)
    cols = mapping.keys
    determine_limits(table, cols)
    header = "INSERT INTO #{table} (#{cols.join(",")}) VALUES "
    footer = " ON DUPLICATE KEY UPDATE #{cols.map { |k| "#{k}=VALUES(#{k})" }.join(",")};"

    warn "Upserting #{table} (#{scope.count} entries)"

    scope.in_batches(of: 500) do |batch|
      rows = []

      batch.find_each do |model|
        rows << "(#{data_values(model, mapping)})"
      end

      upsert = header + rows.join(", ") + footer
      @target.query(upsert)
      $stderr.print "."
    end

    warn " Done."
  end

  def determine_limits(table, columns)
    schema_info = @target.query("DESCRIBE #{table};")

    schema_info.each do |row|
      field_name = row["Field"]

      next unless columns.include?(field_name)

      field_type = row["Type"]

      next unless field_type.start_with?("varchar")

      limit = field_type.gsub(/varchar\((\d+)\)/, '\1').to_i

      next unless limit.positive?

      @schema_limits[field_name] = limit
    end

    @schema_limits
  end

  def data_values(model, mapping)
    data_map(model, mapping).values.join(",")
  end

  def data_map(model, mapping)
    mapping.map do |key, source|
      value = read_value(model, source).then { |val| cast_value(key, val) }

      [key, value]
    end.to_h
  end

  def read_value(model, source)
    if source.respond_to? :call
      source.call(model)
    elsif source.is_a? Symbol
      model.send(source)
    else
      source
    end
  end

  def cast_value(key, value) # rubocop:disable Metrics/CyclomaticComplexity
    case value
    # when String then @target.escape(apply_limits(key, value)).inspect
    when String then apply_limits(key, value).inspect
    when Integer then value
    when ActiveSupport::TimeWithZone then value.strftime("%Y-%m-%d %H:%M").inspect
    when Date then value.strftime("%Y-%m-%d").inspect
    when TrueClass then "1"
    when FalseClass then "0"
    when nil then "NULL"
    end
  end

  def apply_limits(key, value)
    return value if value == "NULL"

    limit = @schema_limits[key]
    return value if limit.blank?

    value[...limit]
  end

  # mappings from different tables

  def person_mapping # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
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
      "AdrEinzelmitglied" => ->(p) { role_type_exists(p.roles, "%Einzelmitglieder%") },
      "AdrNachwuchs" => ->(p) { role_type_exists(p.roles, "%Nachwuchsmitglieder%") },
      "AdrDatU" => :updated_at,

      # not nullable, but not exported
      "AdrWerbung" => 0,
      "AdrNews" => 0,
      "AdrStatus" => 0,
      "AdrVgg" => 0,
      "AdrMc" => 0
    }
  end

  def group_mapping # rubocop:disable Metrics/MethodLength
    @group_mapping ||= {
      "GruAdrNr" => ->(g) { offset_group_id(g.id) },
      "GruMail" => :email,
      "GruName" => :name,
      "GruOrt" => :vereinssitz,
      "GruAdrNrPraesident" => ->(g) { person_id_with_role(g.roles, "%Praesident") || 0 },
      "GruAdrNrDirigent" => ->(g) { person_id_with_role(g.roles, "%Conductor") || 0 },
      "GruUV" => ->(g) { g.parent&.short_name },
      "GruTyp" => ->(g) { g.model_name.human },

      # not nullable, but not exported
      "GruZus" => 0,
      "GruPraesidentSeit" => 0,
      "GruDirigentSeit" => 0,
      "GruKorrAdrNr" => 0,
      "GruGruendungsjahr" => 0,
      "GruBeitrittsjahrEJV" => 0,
      "GruAustrittsjahrEJV" => 0,
      "GruAdrNrVereinigung" => 0,
      "GruFruehereJahre" => 0,
      "GruAnzMitglieder" => 0,
      "GruAlt" => 0,
      "GruJung" => 0,
      "GruMittel" => 0,
      "GruFrauen" => 0,
      "GruBeitragNr" => 0,
      "GruZuschlBetrag" => 0,
      "GruZuschlMitBetrag" => 0,
      "GruGrMc" => 0
    }
  end

  def role_mapping
    @role_mapping ||= {
      "GmiLnr" => :id,
      "GmiEjvNr" => :person_id,
      "GmiEjvNrGrp" => :group_id,

      # not nullable, but not exported
      "GmiEintritt" => 0,
      "GmiAustritt" => 0,
      "GmiGebJahr" => 0,
      "GmiMc" => 0
    }
  end

  def group_addresses_mapping
    @group_addresses_mapping ||= {
      "AdrNr" => ->(g) { offset_group_id(g.id) },
      "AdrNameZ1" => :name,
      "AdrMail" => :email,
      "AdrOrt" => :vereinssitz,
      "AdrUV" => ->(g) { g.parent&.short_name },
      "AdrDatU" => :updated_at,

      # not nullable, but not exported
      "AdrWerbung" => 0,
      "AdrNews" => 0,
      "AdrStatus" => 0,
      "AdrVgg" => 0,
      "AdrMc" => 0
    }
  end

  # lookup tables of hardcoded values

  def relevant_role_types
    %w[
      Group::VereinJodler::Mitglied
      Group::VereinJodlerNachwuchs::Mitglied
      Group::VereinAlphornblaeser::Mitglied
      Group::VereinAlphornblaeserNachwuchs::Mitglied
      Group::VereinFahnenschwinger::Mitglied
      Group::VereinFahnenschwingerNachwuchs::Mitglied
    ]
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

  # dynamic lookups and searches

  def lookup_unterverband(person)
    person.roles
      .where("type LIKE '%Mitglied'")
      .map(&:group).compact
      .map(&:parent).compact
      .map(&:short_name).compact
      .first
  end

  def role_type_exists(roles, type_pattern)
    roles.where("type LIKE ?", type_pattern).exists?
  end

  def person_id_with_role(roles, type_pattern)
    roles.where(["type LIKE ?", type_pattern]).pick(:person_id)
  end

  def offset_group_id(id)
    legacy_threshold = 200_00
    conflict_avoidance_offset = 1_000_000

    id + ((id > legacy_threshold) ? conflict_avoidance_offset : 0)
  end
end
