# discourse-chat-integration-telegram-link-preview

A tiny [Discourse](https://www.discourse.org/) plugin that lets
[discourse-chat-integration](https://github.com/discourse/discourse-chat-integration) show
Telegram's native link preview on its Telegram notifications.

## Why

The upstream plugin hardcodes `disable_web_page_preview: true`, so no preview card is shown. This
plugin sets it to `false`, letting a topic notification render the forum page's link preview.

## Install

Add to `containers/app.yml` under `hooks.after_code`:

```yaml
- git clone https://github.com/Gentoo-zh/discourse-chat-integration-telegram-link-preview.git
```

Then `./launcher rebuild app`, and use a Telegram message template that is just a title link.

## License

MIT
