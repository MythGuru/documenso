# Railway Deployment Checklist

Quick reference for deploying Documenso to Railway.

## Pre-Deployment

- [ ] Supabase database created and accessible
- [ ] Resend SMTP configured with verified domain
- [ ] Signing certificate generated (see `signing-cert.p12`)
- [ ] All secrets generated (see below)
- [ ] Railway account created (sign up with GitHub)

## Generate Secrets

```bash
# NEXTAUTH_SECRET
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"

# Encryption keys
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

## Railway Setup

- [ ] Create new Railway project
- [ ] Connect to GitHub repository: `MythGuru/documenso`
- [ ] Railway detects Dockerfile automatically

## Environment Variables (22 total)

### Database (2)
- [ ] `NEXT_PRIVATE_DATABASE_URL`
- [ ] `NEXT_PRIVATE_DIRECT_DATABASE_URL`

### Application URLs (2)
- [ ] `NEXT_PUBLIC_WEBAPP_URL` (update after first deploy)
- [ ] `NEXTAUTH_URL` (update after first deploy)

### Authentication (1)
- [ ] `NEXTAUTH_SECRET`

### SMTP (7)
- [ ] `NEXT_PRIVATE_SMTP_HOST`
- [ ] `NEXT_PRIVATE_SMTP_PORT`
- [ ] `NEXT_PRIVATE_SMTP_USERNAME`
- [ ] `NEXT_PRIVATE_SMTP_PASSWORD`
- [ ] `NEXT_PRIVATE_SMTP_SECURE`
- [ ] `NEXT_PRIVATE_SMTP_FROM_NAME`
- [ ] `NEXT_PRIVATE_SMTP_FROM_ADDRESS`

### Encryption (2)
- [ ] `NEXT_PRIVATE_ENCRYPTION_KEY`
- [ ] `NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY`

### Signing Certificate (2)
- [ ] `NEXT_PRIVATE_SIGNING_TRANSPORT=local`
- [ ] `NEXT_PRIVATE_SIGNING_PASSPHRASE`
- [ ] `NEXT_PRIVATE_SIGNING_LOCAL_FILE_CONTENTS`

### Optional Config (4)
- [ ] `NEXT_PUBLIC_ALLOW_SIGNUP=false`
- [ ] `NEXT_PRIVATE_MARKETING_DISABLED=true`
- [ ] `NEXT_PUBLIC_BILLING_ENABLED=false`

## Deployment

- [ ] All environment variables added
- [ ] Initial deployment triggered
- [ ] Monitor build logs (5-10 minutes)
- [ ] Build completes successfully
- [ ] Get Railway URL from dashboard
- [ ] Update `NEXT_PUBLIC_WEBAPP_URL` and `NEXTAUTH_URL`
- [ ] Redeploy with updated URLs

## Verification

- [ ] Health check passes: `curl https://your-app.railway.app/api/health`
- [ ] Web interface accessible
- [ ] Check deploy logs for:
  - [ ] `✅ Schema file found!`
  - [ ] `✅ Migrations completed successfully!`
  - [ ] `🌟 Starting Documenso server...`

## Post-Deployment

- [ ] Create admin account (first user)
- [ ] Verify email address
- [ ] Generate API token in Settings → API Tokens
- [ ] Save API token to credentials file
- [ ] Test document creation via API

## Integration with VetNPLab Portal

- [ ] Update `.env.local` with Railway URL
- [ ] Update `.env.local` with API token
- [ ] Deploy VetNPLab Portal
- [ ] Test prescription signing workflow

## Troubleshooting

### Health Check Fails
1. Check database connection
2. Verify all environment variables are set
3. Check deploy logs for errors

### Prisma Schema Not Found
- Should be fixed in latest version
- Check deploy logs for directory listings

### Database Migration Errors
1. Verify database credentials
2. Check Supabase firewall settings
3. Review migration logs

## Support

- **Deployment Guide:** `docs/documenso-railway-deployment.md`
- **Documenso Docs:** https://docs.documenso.com
- **Railway Docs:** https://docs.railway.app

