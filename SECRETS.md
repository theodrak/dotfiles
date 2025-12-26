# Managing Secrets in Your Dotfiles

## Setup

1. Create a `~/.env.local` file in your home directory:
   ```bash
   touch ~/.env.local
   chmod 600 ~/.env.local  # Make it readable only by you
   ```

2. Add your API keys and secrets to `~/.env.local`:
   ```bash
   export OPENAI_API_KEY="your-new-api-key-here"
   export OTHER_SECRET="value"
   ```

3. Your `.zshrc` will automatically load this file when you open a new terminal.

## Important

- **Never commit `.env.local` to git** - it's already in `.gitignore`
- **Revoke any exposed keys** immediately if they're committed by accident
- **Keep a backup** of your `.env.local` in a secure password manager

## Getting a New OpenAI API Key

1. Go to https://platform.openai.com/api-keys
2. Delete the old exposed key
3. Create a new key
4. Add it to `~/.env.local`
