# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :rank_tracker,
  ecto_repos: [RankTracker.Repo],
  generators: [context_app: :rank_tracker]

config :rank_tracker_web,
  ecto_repos: [RankTracker.Repo],
  generators: [context_app: :rank_tracker]

# Configures the endpoint
config :rank_tracker_web, RankTrackerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: RankTrackerWeb.ErrorHTML, json: RankTrackerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RankTracker.PubSub,
  live_view: [signing_salt: "A//BKf/K"]

# Configure Mix tasks and generators
config :hello_app,
  ecto_repos: [HelloApp.Repo],
  generators: [context_app: :hello_app]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :hello_app, HelloApp.Mailer, adapter: Swoosh.Adapters.Local

config :hello_app_web,
  ecto_repos: [HelloApp.Repo],
  generators: [context_app: :hello_app]

# Configures the endpoint
config :hello_app_web, HelloAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: HelloAppWeb.ErrorHTML, json: HelloAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: HelloApp.PubSub,
  live_view: [signing_salt: "rh65NHRw"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  hello_app_web: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../apps/hello_app_web/assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ],
  rank_tracker_web: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../apps/rank_tracker_web/assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  hello_app_web: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("../apps/hello_app_web", __DIR__)
  ],
  rank_tracker_web: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("../apps/rank_tracker_web", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
