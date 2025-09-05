# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe Person::LoginMailer do
  before do
    CustomContent.where(key: Person::LoginMailer::CONTENT_LOGIN).destroy_all
    content = CustomContent.new(key: Person::LoginMailer::CONTENT_LOGIN,
      placeholders_required: "login-url",
      placeholders_optional: "recipient-name, sender-name, dachverband")
    content.save(validate: false)

    CustomContent::Translation.create!(custom_content_id: content.id,
      locale: "de",
      label: "Login senden",
      subject: "Willkommen bei #{Settings.application.name}",
      body: body)
  end

  let(:mail) { Person::LoginMailer.login(people(:member), people(:leader), "abcdef") }
  let(:body) { "Hallo" }

  context "placeholders" do
    let(:body) { "Hallo {recipient-name}<br/><br/>Dein {dachverband}" }

    subject { mail.body }

    it "populates dachverband placeholder" do
      expect(subject).to match(/Dein Eidgenössischer Jodlerverband/)
    end

    it "populates recipient-name placeholder" do
      expect(subject).to match(/#{people(:member).first_name}/)
    end
  end
end
