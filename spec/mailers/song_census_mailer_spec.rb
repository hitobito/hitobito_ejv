# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SongCensusMailer do
  before do
    SeedFu.quiet = true
    SeedFu.seed [HitobitoEjv::Wagon.root.join("db", "seeds")]
  end

  let(:person) { people(:suisa_admin) }
  let(:group) { groups(:jodlerklub_edelweiss_thun) }

  subject { mail }

  describe "#reminder" do
    context "includes content" do
      let(:mail) { SongCensusMailer.reminder(person, group) }

      its(:subject) { is_expected.to eql "Meldeliste ausfüllen!" }
      its(:from) { is_expected.to eql ["noreply@localhost"] }
      its(:to) { is_expected.to eql [person.email] }
      its(:body) { is_expected.to match(/Hallo Suisa Boy/) }
      its(:body) { is_expected.to match(/die Meldeliste für den Verein 'Jodlerklub Edelweiss Thun'/) }
      its(:body) { is_expected.to match(/Dein EJV/) }
    end
  end
end
