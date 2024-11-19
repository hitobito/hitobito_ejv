# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::MailRelay::Lists
  extend ActiveSupport::Concern

  def envelope_sender
    self.class.personal_return_path(envelope_receiver_name, sender_email, mail_domain)
  end

  def mail_domain
    mailing_list.mail_domain
  end
end
