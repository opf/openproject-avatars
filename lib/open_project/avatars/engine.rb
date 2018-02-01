# OpenProject Avatars plugin
#
# Copyright (C) 2017 OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module OpenProject::Avatars
  class Engine < ::Rails::Engine
    engine_name :openproject_avatars

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-avatars',
             author_url: 'https://www.openproject.com',
             global_assets: { css: 'avatars/openproject_avatars' },
             settings: {
               default: {
                 enable_gravatars: true,
                 gravatar_default: 'mm',
                 enable_local_avatars: true
               },
               partial: 'settings/openproject_avatars'
             },
             requires_openproject: '>= 7.0.0' do

      add_menu_item :my_menu, :avatar,
                    { controller: 'avatars/my_avatar', action: 'show' },
                    caption: ->(*) { I18n.t('avatars.label_avatar') },
                    if: ->(*) { ::OpenProject::Avatars::AvatarManager::avatars_enabled? },
                    icon: 'icon2 icon-image1'
    end

    config.to_prepare do
      require_dependency 'project'
    end

    initializer 'patch avatar helper' do
      # This is required to be an initializer,
      # since the helpers are included as soon as the ApplicationController
      # gets autoloaded, which is BEFORE config.to_prepare.
      require_relative 'patches/avatar_helper_patch'
    end

    patches %i[User
               UsersHelper]
  end
end
