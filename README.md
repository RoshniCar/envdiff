# envdiff

Compare `.env` files and spot the differences. Minimal, focused, useful.

## Installation

```bash
gem install envdiff
```

Or add to your Gemfile:

```ruby
gem 'envdiff'
```

## Usage

```bash
# Compare two env files
envdiff .env .env.production

# Output:
# Only in .env:
#   - DEBUG_MODE
#
# Only in .env.production:
#   + SENTRY_DSN
#
# Different values:
#   DATABASE_URL:
#     .env: postgres://localhost/myapp_dev
#     .env.production: postgres://prod-server/myapp
#
# 12 matching, 1 only in .env, 1 only in .env.production, 1 different
```

### Options

```bash
envdiff --help

Options:
  --no-color    Disable colored output
  -q, --quiet   Only show if files differ (exit code)
  -v, --version Show version
  -h, --help    Show this help
```

### CI/CD Usage

Use `--quiet` to fail builds when env files are out of sync:

```bash
envdiff .env.example .env.production --quiet || echo "Env files out of sync!"
```

## Features

- Coloured terminal output
- Auto-masks sensitive values (tokens, API keys)
- 🚀 Clean summary of differences
- ✅ Exit codes for CI/CD integration

## License

MIT
