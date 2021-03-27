require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module BookTours
  class Application < Rails::Application
    config.load_defaults 6.0

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    I18n.available_locales = [:en, :vi]
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
  end
end
