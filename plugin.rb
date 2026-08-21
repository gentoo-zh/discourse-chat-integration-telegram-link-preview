# frozen_string_literal: true

# name: discourse-chat-integration-telegram-link-preview
# about: Let discourse-chat-integration's Telegram notifications show Telegram's native link preview.
# version: 1.0.0
# authors: Zakk
# url: https://github.com/Gentoo-zh/discourse-chat-integration-telegram-link-preview

# Upstream hardcodes disable_web_page_preview: true on Telegram notifications; flip it to false so
# the forum page's link preview renders.
module ::ChatIntegrationTelegramLinkPreview
  def sendMessage(message)
    message = message.merge(disable_web_page_preview: false) if message.is_a?(Hash)
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
