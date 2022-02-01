import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chatbot, ChatbotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TG0Tj0AufbI2/osj8LdOPfom0mcTOy9+OUnBq2ZTlTflM5ZRewMO50WltW5ObLZn",
  server: false

# In test we don't send emails.
config :chatbot, Chatbot.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
