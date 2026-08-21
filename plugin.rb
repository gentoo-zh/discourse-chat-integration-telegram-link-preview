# frozen_string_literal: true

# name: discourse-chat-integration-telegram-link-preview
# about: Telegram link preview (disabled/small/large) and optional category path on discourse-chat-integration notifications.
# version: 1.2.0
# authors: Zakk
# url: https://github.com/Gentoo-zh/discourse-chat-integration-telegram-link-preview

# Two enhancements to the discourse-chat-integration Telegram provider:
#   chat_integration_telegram_link_preview          -> preview card: disabled / small / large
#   chat_integration_telegram_link_preview_category -> prepend the topic's category path
module ::ChatIntegrationTelegramLinkPreview
  # Upstream hardcodes disable_web_page_preview: true. Swap in the modern
  # link_preview_options so a small/large card can be shown instead.
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

  # Build the notification text from this plugin's own strings so the wording and the
  # optional category path stay in one place. Falls back to upstream on anything unexpected.
  def message_text(post)
    return super unless SiteSetting.respond_to?(:chat_integration_telegram_link_preview_category)
    topic = post&.topic
    return super if topic.nil?

    path =
      if SiteSetting.chat_integration_telegram_link_preview_category
        link_preview_category_path(topic.category)
      end
    key =
      path ? "chat_integration_telegram_link_preview.message_with_category" :
        "chat_integration_telegram_link_preview.message"

    I18n.t(
      key,
      user: DiscourseChatIntegration::Helper.formatted_display_name(post.user),
      category: path,
      post_url: post.full_url,
      title: CGI.escapeHTML(topic.title),
    )
  end

  # "Parent/Child" for a nested category, escaped for HTML parse_mode. nil when uncategorized.
  def link_preview_category_path(category)
    return nil if category.nil?
    parts = []
    node = category
    while node
      parts.unshift(node.name)
      node = node.parent_category
    end
    return nil if parts.empty?
    CGI.escapeHTML(parts.join("/"))
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
