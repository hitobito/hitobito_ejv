# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

class Events::GroupParticipationsController < CrudController
  include AsyncDownload

  self.nesting = [Group, Event]
  self.permitted_attrs = [
    :music_style,
    :music_type,
    :music_level,
    :parade_music,
    :group_id,
    :joint_participation,
    :secondary_group_id,
    :secondary_group_is_primary
  ]

  self.sort_mappings = {
    group_id: "groups.name"
  }

  decorates :event

  before_action :participating_group, only: [:new, :edit]
  prepend_before_action :correct_nesting_in_new_entry, only: [:new, :create]
  prepend_before_action :entry, only: ACTIONS + [:edit_stage]
  around_save :update_state_machine

  def edit_stage
    edit_event = :"edit_#{params[:edit_stage]}"

    if entry.respond_to?(edit_event)
      entry.send(edit_event)
      entry.save!(validate: false)
    end

    redirect_to return_path
  end

  def index
    super do |format|
      format.csv { render_tabular_in_background(:csv) }
      format.xlsx { render_tabular_in_background(:xlsx) }
    end
  end

  private_class_method :model_class

  def self.model_class
    Event::GroupParticipation
  end

  private

  def list_entries
    super.includes(:group, :secondary_group, :event)
  end

  def return_path
    edit_group_event_group_participation_path(
      @group, @event, entry,
      participating_group: participating_group_id
    )
  end

  def render_tabular_in_background(format)
    with_async_download_cookie(
      format, "anmeldungen-#{@event.name.parameterize}"
    ) do |filename|
      Export::GroupParticipationsExportJob.new(
        format, current_person.id, entry.event.id,
        filename: filename
      ).enqueue!
    end
  end

  def update_state_machine
    maybe_join_participations

    entry.progress_for(participating_group || entry.group)
    yield.tap do |result|
      entry.rollback_state_if_invalid(result)
    end
  end

  def participating_group
    @participating_group ||= Group.find_by(id: participating_group_id).try(:layer_group)
  end

  def correct_nesting_in_new_entry
    if entry.new_record?
      entry.group_id ||= params["participating_group"] ||
        params["event_group_participation"]["group_id"]
    end
  end

  def participating_group_id # rubocop:disable Metrics/AbcSize any refactoring inside the methods makes it harder to understand
    if params["participating_group"].present?
      params["participating_group"]
    elsif params.fetch("event_group_participation", {}).fetch("participating_group", nil).present?
      params["event_group_participation"]["participating_group"]
    elsif params["group_id"].to_i != entry.event.group_ids.first
      @group.id # loaded by calling "entry"
    else
      entry.group_id
    end
  end

  def maybe_join_participations
    return unless entry.primary_joint_participation_selected?
    return unless entry.secondary_group_is_primary == "1"

    join_participations!(primary_entry: model_class.find_by(group_id: entry.secondary_group_id),
      secondary_entry: entry)
  end

  def join_participations!(primary_entry:, secondary_entry:)
    return if primary_entry.blank?

    primary_entry.join_secondary
    primary_entry.joint_participation = true
    primary_entry.secondary_group = secondary_entry.group

    if primary_entry.primary_opened?
      primary_entry.state = model_class::STATE_PRIMARY_JOINT_PARTICIPATION_SELECTED
    end

    secondary_entry.destroy!
    model_ivar_set(primary_entry)
  end
end
