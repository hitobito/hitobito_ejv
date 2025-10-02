# frozen_string_literal: true

#  Copyright (c) 2012-2025, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::Groups::SelfRegistrationController
  extend ActiveSupport::Concern

  delegate :email, to: :wizard

  prepended do
    before_action :restrict_access
  end

  private

  def restrict_access
    redirect_to_login if !signed_in? && email_exists?
  end

  def email_exists? = email.present? && Person.exists?(email: email)

  def model_class
    case group
    when Group::RootNeumitglieder
      Wizards::Signup::RootNeumitgliederWizard
    else
      super
    end
  end

  def redirect_to_group_if_necessary
    redirect_to group_path(group) unless group.self_registration_active?
  end

  def success_message
    if current_user.present?
      t("groups.self_registration.create.success_message")
    else
      super
    end
  end

  def redirect_target
    if current_user.present?
      dashboard_path
    else
      super
    end
  end

  def redirect_to_login
    person = Person.find_by(email: email)
    store_location_for(person, group_self_registration_path(group))

    path = new_person_session_path(person: {login_identity: email})
    notice = t("groups.self_registration.create.redirect_existing_email")

    return redirect_to(path, notice: notice) unless request.xhr?

    flash[:notice] = notice
    render js: "window.location='#{path}';"
  end
end
