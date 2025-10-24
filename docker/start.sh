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
# Try different paths for the schema file
if [ -f "../../packages/prisma/schema.prisma" ]; then
    npx prisma migrate deploy --schema ../../packages/prisma/schema.prisma
elif [ -f "../packages/prisma/schema.prisma" ]; then
    npx prisma migrate deploy --schema ../packages/prisma/schema.prisma
elif [ -f "/app/packages/prisma/schema.prisma" ]; then
    npx prisma migrate deploy --schema /app/packages/prisma/schema.prisma
else
    printf "⚠️  Warning: Could not find Prisma schema file, skipping migrations\n"
    printf "📂 Current directory: $(pwd)\n"
    printf "📂 Directory contents:\n"
    ls -la
    printf "📂 Parent directory contents:\n"
    ls -la ..
    printf "📂 /app contents:\n"
    ls -la /app
fi

printf "🌟 Starting Documenso server...\n"
HOSTNAME=0.0.0.0 node build/server/main.js
