module OpenProject
  module Avatars
    module AvatarManager
      class << self
        def avatars_enabled?
          gravatar_enabled? || local_avatars_enabled?
        end

        def settings
          (Setting.plugin_openproject_avatars || {}).with_indifferent_access
        end

        def gravatar_enabled?
          val = settings[:enable_gravatars]
          ActiveModel::Type::Boolean.new.cast(val)
        end

        def default_gravatar_options
          [
            [I18n.t(:label_none), '404'],
            ["Mystery Man", 'mm'],
            ["Wavatars", 'wavatar'],
            ["Identicons", 'identicon'],
            ["Monster ids", 'monsterid'],
            ["Robohash", 'robohash'],
            ["Retro", 'retro']
          ]
        end

        def local_avatars_enabled?
          val = settings[:enable_local_avatars]
          ActiveModel::Type::Boolean.new.cast(val)
        end
      end
    end
  end
end
