# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

# == Schema Information
#
# Table name: songs
#
#  id           :integer          not null, primary key
#  title        :string(255)      not null
#  composed_by  :string(255)      not null
#  arranged_by  :string(255)
#  published_by :string(255)
#  suisa_id     :integer
#

class Song < ActiveRecord::Base
  has_many :song_counts, dependent: :destroy

  scope :list, -> { order(:title) }

  validates_by_schema
  validates :title, uniqueness: { # rubocop:disable Rails/UniqueValidationWithoutIndex
    scope: [:composed_by, :arranged_by, :published_by],
    case_sensitive: true
  }

  def to_s
    title
  end
end
