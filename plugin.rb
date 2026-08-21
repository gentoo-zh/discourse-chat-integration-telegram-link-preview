# frozen_string_literal: true

# name: discourse-chat-integration-telegram-link-preview
# about: Choose the Telegram link preview (disabled / small / large) on discourse-chat-integration Telegram notifications.
# version: 1.1.0
# authors: Zakk
# url: https://github.com/Gentoo-zh/discourse-chat-integration-telegram-link-preview

# Upstream hardcodes disable_web_page_preview: true (no preview). The
# chat_integration_telegram_link_preview setting selects the preview per send:
#   disabled -> keep upstream default (no card)
#   small    -> compact thumbnail
#   large    -> large image
module ::ChatIntegrationTelegramLinkPreview
  def sendMessage(message)
    if message.is_a?(Hash) && SiteSetting.respond_to?(:chat_integration_telegram_link_preview)
      case SiteSetting.chat_integration_telegram_link_preview
      when "small"
        message = message.merge(link_preview_options: { prefer_small_media: true })
        message.delete(:disable_web_page_preview)
      when "large"
        message = message.merge(link_preview_options: { prefer_large_media: true })
        message.delete(:disable_web_page_preview)
      end
    end
    super
  end
end

after_initialize do
  # The provider is loaded lazily and after us, so load discourse-chat-integration's own initializer
  # (it requires every dependency in order), then patch. Guarded so a failure can never break boot.
  begin
    init =
      File.expand_path(
        "../discourse-chat-integration/app/initializers/discourse_chat_integration.rb",
        __dir__,
      )
    require init if File.exist?(init)
    if defined?(::DiscourseChatIntegration::Provider::TelegramProvider)
      ::DiscourseChatIntegration::Provider::TelegramProvider.singleton_class.prepend(
        ::ChatIntegrationTelegramLinkPreview,
      )
    end
  rescue => e
    Rails.logger.warn("chat-integration-telegram-link-preview: #{e.class}: #{e.message}")
  end
end
