#!/bin/sh

# 🚀 Starting Documenso...
printf "🚀 Starting Documenso...\n\n"

# 🔐 Check certificate configuration
printf "🔐 Checking certificate configuration...\n"

CERT_PATH="${NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH:-/opt/documenso/cert.p12}"

if [ -f "$CERT_PATH" ] && [ -r "$CERT_PATH" ]; then
    printf "✅ Certificate file found and readable - document signing is ready!\n"
else
    printf "⚠️  Certificate not found or not readable\n"
    printf "💡 Tip: Documenso will still start, but document signing will be unavailable\n"
    printf "🔧 Check: http://localhost:3000/api/certificate-status for detailed status\n"
fi

printf "\n📚 Useful Links:\n"
printf "📖 Documentation: https://docs.documenso.com\n"
printf "🐳 Self-hosting guide: https://docs.documenso.com/developers/self-hosting\n"
printf "🔐 Certificate setup: https://docs.documenso.com/developers/self-hosting/signing-certificate\n"
printf "🏥 Health check: http://localhost:3000/api/health\n"
printf "📊 Certificate status: http://localhost:3000/api/certificate-status\n"
printf "👥 Community: https://github.com/documenso/documenso\n\n"

printf "🗄️  Running database migrations...\n"
printf "📂 Current directory: $(pwd)\n"

# Use absolute path for Prisma schema
SCHEMA_PATH="/app/packages/prisma/schema.prisma"

printf "🔍 Checking for schema at: $SCHEMA_PATH\n"
if [ -f "$SCHEMA_PATH" ]; then
    printf "✅ Schema file found!\n"
    printf "🔄 Running migrations...\n"
    npx prisma migrate deploy --schema "$SCHEMA_PATH"
    MIGRATION_EXIT_CODE=$?
    if [ $MIGRATION_EXIT_CODE -eq 0 ]; then
        printf "✅ Migrations completed successfully!\n"
    else
        printf "❌ Migrations failed with exit code: $MIGRATION_EXIT_CODE\n"
        printf "⚠️  Continuing anyway to allow debugging...\n"
    fi
else
    printf "❌ Schema file not found at: $SCHEMA_PATH\n"
    printf "📂 Listing /app directory:\n"
    ls -la /app || printf "Cannot list /app\n"
    printf "📂 Listing /app/packages directory:\n"
    ls -la /app/packages || printf "Cannot list /app/packages\n"
    printf "⚠️  Skipping migrations - app may not work correctly!\n"
fi

printf "🌟 Starting Documenso server...\n"
# Railway sets PORT environment variable, default to 3000 if not set
export PORT="${PORT:-3000}"
printf "🌐 Server will listen on port: $PORT\n"
printf "🌐 Binding to: 0.0.0.0:$PORT\n"
HOSTNAME=0.0.0.0 node build/server/main.js
