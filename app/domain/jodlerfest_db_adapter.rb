# frozen_string_literal: true

#  Copyright (c) 2026-2026, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# technical steps to transform our DB-Data into MySQL-Updates
class JodlerfestDbAdapter
  def initialize(target_db_client)
    @target = target_db_client

    @schema_limits = {}
  end

  def send_data(table, mapping, scope)
    cols = mapping.keys
    header = "INSERT INTO #{table} (#{cols.join(",")}) VALUES "
    footer = " ON DUPLICATE KEY UPDATE #{cols.map { |k| "#{k}=VALUES(#{k})" }.join(",")};"

    warn "Upserting #{table} (#{scope.count} entries)"

    determine_limits(table, cols)

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
end
