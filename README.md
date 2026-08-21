# discourse-chat-integration-telegram-link-preview

A small [Discourse](https://www.discourse.org/) plugin for
[discourse-chat-integration](https://github.com/discourse/discourse-chat-integration) Telegram
notifications: it controls Telegram's link preview and can prepend the topic's category path.
The notification wording lives in this plugin (`server.*.yml`) as a clean title link.

## Settings

`chat_integration_telegram_link_preview` (default `small`) — the link preview card:

- `disabled` — no card
- `small` — compact thumbnail
- `large` — large image

`chat_integration_telegram_link_preview_category` (default `off`) — show the topic's category
path, e.g. `<user> posted a new topic in Parent/Child: <title>`.

The preview setting takes effect at runtime; the category setting is read on send.

## Install

Add to `containers/app.yml` under `hooks.after_code`:

```yaml
- git clone https://github.com/Gentoo-zh/discourse-chat-integration-telegram-link-preview.git
```

Then `./launcher rebuild app`.

## License

MIT
