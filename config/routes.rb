# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

Rails.application.routes.draw do
  extend LanguageRouteScope

  language_scope do
    # Define wagon routes here

    resources :songs
    resources :jobs do
      member do
        put "run"
      end
    end

    resources :groups, only: [] do
      member do
        get :subverein_select
      end

      resources :song_counts
      resources :concerts do
        collection do
          post "submit"
        end
      end

      resources :song_censuses, only: [:new, :create, :index] do
        post "remind", to: "song_censuses#remind"
      end
    end
    get "/groups/query" => "groups/query#index", :as => :query_groups

    get "help" => "help#index"
  end
end
