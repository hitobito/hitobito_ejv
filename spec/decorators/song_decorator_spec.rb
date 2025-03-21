# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

require "spec_helper"

describe SongDecorator, :draper_with_helpers do
  subject { SongDecorator.new(song) }

  context "#full_label" do
    let(:song) do
      Song.create(title: "bar",
        composed_by: "foo",
        arranged_by: "",
        published_by: "<script>alert('test')</script>")
    end

    context "escapes js and does not show null value" do
      its(:full_label) do
        is_expected.to eql "<strong>bar</strong> <span class=\"muted\">foo | &lt;script&gt;alert(&#39;test&#39;)&lt;/script&gt;</span>"
      end
    end
  end
end
