# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::ApplicationMailer
  extend ActiveSupport::Concern

  def return_path(sender)
    MailRelay::Lists.personal_return_path(MailRelay::Lists.app_sender_name,
      sender.email,
      sender.primary_group.try(:hostname_from_hierarchy))
  end
end
