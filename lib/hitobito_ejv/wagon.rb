# frozen_string_literal: true

#  Copyright (c) 2012-2024, Eidgenössischer Jodlerverband. This file is part of
#  hitobito_ejv and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_ejv.

module HitobitoEjv
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement ">= 0"

    # Add a load path for this specific wagon
    config.autoload_paths += %W[
      #{config.root}/app/abilities
      #{config.root}/app/domain
      #{config.root}/app/jobs
      #{config.root}/app/validators
    ]

    config.to_prepare do # rubocop:disable Metrics/BlockLength
      JobManager.wagon_jobs += [RefreshActiveYearsJob]

      # extend application classes here
      # models
      Event.include Ejv::Event
      Group.include Ejv::Group
      Group.include Ejv::Group::NestedSet
      Person.include Ejv::Person
      Role.include Ejv::Role
      InvoiceItem.add_type_mapping(:membership_fee, InvoiceItem::MembershipFee)
      Subscription.prepend Ejv::Subscription
      MailingList.prepend Ejv::MailingList

      unused_event_fields = [
        :motto, :signature, :signature_confirmation, :signature_confirmation_text
      ]
      Event.used_attributes -= unused_event_fields
      Event::Course.used_attributes -= (unused_event_fields + [:requires_approval])
      Event::ParticipationContactData.include Ejv::Event::ParticipationContactData

      ### controllers
      GroupsController.permitted_attrs += [:vereinssitz, :founding_year,
        :besetzung,
        :klasse, :unterhaltungsmusik,
        :secondary_parent_id, :tertiary_parent_id,
        :subventionen, :hostname,
        :buv_lohnsumme, :nbuv_lohnsumme, :manual_member_count]

      PeopleController.permitted_attrs += [
        :profession,
        :correspondence_language,
        :personal_data_usage
      ]

      Person::HistoryController.prepend Ejv::Person::HistoryController
      DeviseController.include HostnamedGroups

      ### helpers
      admin = NavigationHelper::MAIN.find { |opts| opts[:label] == :admin }
      admin[:active_for] << "songs"

      index_admin = NavigationHelper::MAIN.index { |opts| opts[:label] == :admin }
      NavigationHelper::MAIN.insert(
        index_admin,
        label: :help,
        icon_name: :"info-circle",
        url: :help_path
      )

      GroupsHelper.include Ejv::GroupsHelper
      GroupDecorator.prepend Ejv::GroupDecorator
      StandardFormBuilder.include Ejv::StandardFormBuilder
      Dropdown::InvoiceNew.prepend Ejv::Dropdown::InvoiceNew

      ### sheets
      Sheet::Group.include Ejv::Sheet::Group

      ### jobs
      Export::SubgroupsExportJob.prepend Ejv::Export::SubgroupsExportJob

      ### mailers
      Person::LoginMailer.prepend Ejv::Person::LoginMailer
      ApplicationMailer.prepend Ejv::ApplicationMailer

      ### domain
      Export::Pdf::List::People.prepend Ejv::Export::Pdf::List::People

      Export::Tabular::Groups::Row.include Ejv::Export::Tabular::Groups::Row
      Export::Tabular::Groups::List.prepend Ejv::Export::Tabular::Groups::List
      Export::Tabular::People::PeopleFull.include Ejv::Export::Tabular::People::PeopleFull

      MailRelay::Lists.prepend Ejv::MailRelay::Lists

      additional_person_attrs = [
        :active_years
      ]

      TableDisplay.register_column(Person,
        TableDisplays::ShowDetailsColumn,
        additional_person_attrs)

      ### abilities
      RoleAbility.include Ejv::RoleAbility
      GroupAbility.include Ejv::GroupAbility
      PersonAbility.include Ejv::PersonAbility

      # uv_lohnsumme allows to manage the salary amount for the accident insurance
      Role::Permissions << :uv_lohnsumme

      # load this class after all abilities have been defined
      AbilityDsl::UserContext::GROUP_PERMISSIONS << :song_census

      AbilityDsl::UserContext::GROUP_PERMISSIONS << :uv_lohnsumme
      AbilityDsl::UserContext::LAYER_PERMISSIONS << :uv_lohnsumme

      # lastly, register the abilities (could happen earlier, it's just a nice conclusion here)
      Ability.store.register SongAbility
    end

    initializer "ejv.add_settings" do |_app|
      Settings.add_source!(File.join(paths["config"].existent, "settings.yml"))
      Settings.reload!
    end

    initializer "ejv.add_inflections" do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular "song_census", "song_censuses"
        inflect.plural "klasse", "klassen"
        inflect.plural "unterhaltungsmusik", "unterhaltungsmusik_stufen"
        inflect.plural "besetzung", "besetzungen"
      end
    end

    private

    def seed_fixtures
      fixtures = root.join("db", "seeds")
      ENV["NO_ENV"] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)] # rubocop:disable Rails/EnvironmentVariableAccess This is initialization
    end
  end
end
