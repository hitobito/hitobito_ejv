# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module Ejv::Group
  extend ActiveSupport::Concern

  # rubocop:todo Layout/LineLength
  FQDN_REGEX = '(?=\A.{1,254}\z)(\A(([a-z0-9][a-z0-9\-]{0,61}[a-z0-9])\.)+([a-z0-9][a-z0-9\-]{0,61}[a-z0-9]))\z'
  # rubocop:enable Layout/LineLength

  included do # rubocop:disable Metrics/BlockLength
    # allow to have Kontakte everywhere
    children Group::Kontakte

    # set after global children are defined
    root_types Group::Root

    include I18nSettable
    include I18nEnums

    validates :manual_member_count,
      numericality: {greater_than_or_equal_to: 0},
      if: :manually_counted_members?
  end

  def uses_manually_counted_members?
    manually_counted_members? && manual_member_count.present? && manual_member_count.nonzero?
  end

  def recognized_members
    uses_manually_counted_members? ? manual_member_count : member_count
  end

  def mitgliederverband
    ancestors.find_by(type: Group::Mitgliederverband.sti_name)
  end

  def song_counts
    verein_sql = descendants.where(type: Group::VereinJodler).without_deleted.select(:id).to_sql
    SongCount.joins(:concert).where("concerts.verein_id IN (#{verein_sql})")
  end

  def member_count
    return unless is_a?(Group::Verein)

    Group::VereinJodler::Mitglied.where(group_id: id).count
  end
end
