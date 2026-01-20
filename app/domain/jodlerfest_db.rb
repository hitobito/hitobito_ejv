# frozen_string_literal: true

#  Copyright (c) 2025-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "uri"
require "mysql2"

class JodlerfestDb
  attr_reader :client

  def initialize(connection_url)
    uri = URI.parse(connection_url)

    @username = uri.user
    @password = uri.password
    @host = uri.host
    @port = uri.port
    @database = uri.path.delete_prefix("/")

    @client = nil
  end

  def connect
    @client ||= Mysql2::Client.new(
      host: @host,
      port: @port,
      username: @username,
      password: @password,
      database: @database
    )
  end
end
