# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class SongCount < ActiveRecord::Base
  belongs_to :song
  belongs_to :concert, touch: true

  validates :count, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 30}, if: :count
  validates :song_id, uniqueness: {scope: :concert}

  delegate :title, :composed_by, :arranged_by, :published_by, :suisa_id,
    to: :song
  delegate :verein, :verein_id, :mitgliederverband, :mitgliederverband_id, :song_census,
    to: :concert

  scope :in, ->(year) { where(year: year) }
  scope :ordered, -> { joins(:song).order("songs.title") }

  def to_s
    song.to_s
  end

  def empty?
    count.to_i.zero?
  end
end
