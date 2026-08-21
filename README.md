# discourse-chat-integration-telegram-link-preview

A tiny [Discourse](https://www.discourse.org/) plugin that controls Telegram's link preview on
[discourse-chat-integration](https://github.com/discourse/discourse-chat-integration) Telegram
notifications. Upstream hardcodes the preview off; this plugin makes it a choice.

## Setting

`chat_integration_telegram_link_preview` (default `small`):

- `disabled` — no preview card
- `small` — compact thumbnail
- `large` — large image

Changed at runtime; no restart needed.

## Install

Add to `containers/app.yml` under `hooks.after_code`:

```yaml
- git clone https://github.com/Gentoo-zh/discourse-chat-integration-telegram-link-preview.git
```

Then `./launcher rebuild app`, and use a Telegram message template that is just a title link.

## License

MIT
