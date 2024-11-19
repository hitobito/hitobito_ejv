# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

namespace :app do
  namespace :license do
    task :config do
      @licenser = Licenser.new("hitobito_ejv",
        "Eidgenössischer Jodlerverband",
        "https://github.com/hitobito/hitobito_ejv")
    end
  end
end
