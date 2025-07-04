# CI/CD Setup Guide for CusrsorTesting iOS App

This guide explains how to set up and use the Continuous Integration/Continuous Deployment (CI/CD) pipeline for the CusrsorTesting iOS app.

## 🚀 Overview

The CI/CD pipeline includes:
- **Automated Testing**: Build and test on every push/PR
- **Code Quality Checks**: SwiftLint and TODO comment detection
- **Automated Deployment**: Deploy to TestFlight on main branch
- **Code Signing**: Secure certificate and provisioning profile management

## 📋 Prerequisites

### 1. GitHub Repository Setup
- Push your code to a GitHub repository
- Enable GitHub Actions in your repository settings

### 2. Apple Developer Account
- Active Apple Developer Program membership
- App Store Connect access
- App Store Connect API Key (recommended)

### 3. Code Signing Setup
- Create a private repository for certificates (e.g., `yourcompany/certificates`)
- Set up Match for certificate management

## 🔧 Configuration Steps

### Step 1: Update Bundle Identifier
Update the bundle identifier in these files:
- `CusrsorTesting/fastlane/Appfile`
- `CusrsorTesting/fastlane/Matchfile`
- `CusrsorTesting/fastlane/Fastfile`

Replace `com.yourcompany.CusrsorTesting` with your actual bundle identifier.

### Step 2: Configure Apple Developer Settings
Update these files with your Apple Developer information:

**Appfile:**
```ruby
app_identifier("com.yourcompany.CusrsorTesting")
apple_id("your-apple-id@example.com")
itc_team_id("123456789") # Find in App Store Connect
team_id("ABC123DEF4") # Find in Apple Developer Portal
```

**Matchfile:**
```ruby
git_url("https://github.com/yourcompany/certificates.git")
username("your-apple-id@example.com")
```

### Step 3: Set Up GitHub Secrets
Go to your GitHub repository → Settings → Secrets and variables → Actions, and add these secrets:

#### Required Secrets:
- `APP_STORE_CONNECT_API_KEY`: Your App Store Connect API private key
- `APP_STORE_CONNECT_API_KEY_ID`: Your App Store Connect API key ID
- `APP_STORE_CONNECT_API_ISSUER_ID`: Your App Store Connect API issuer ID
- `MATCH_PASSWORD`: Password for your certificates repository
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`: App-specific password for your Apple ID

#### Optional Secrets:
- `SLACK_URL`: Webhook URL for Slack notifications

### Step 4: Set Up Code Signing
1. Create a private repository for certificates
2. Run locally to set up certificates:
```bash
cd CusrsorTesting
bundle install
fastlane match development
fastlane match appstore
```

## 🔄 Workflow Overview

### On Push to `develop` branch:
1. ✅ Build the project
2. ✅ Run tests
3. ✅ Code quality checks (SwiftLint)
4. ✅ Check for TODO comments

### On Push to `main` branch:
1. ✅ All develop branch checks
2. ✅ Deploy to TestFlight
3. ✅ Create git tag
4. ✅ Optional Slack notification

### On Pull Request:
1. ✅ Build the project
2. ✅ Run tests
3. ✅ Code quality checks
4. ✅ Check for TODO comments

## 🛠️ Local Development

### Install Dependencies
```bash
cd CusrsorTesting
bundle install
```

### Run Tests Locally
```bash
fastlane test
```

### Build for Development
```bash
fastlane build_dev
```

### Deploy to TestFlight (Manual)
```bash
fastlane beta
```

### Release to App Store (Manual)
```bash
fastlane release
```

## 📱 Deployment Process

### TestFlight Deployment (Automatic)
- Triggered on push to `main` branch
- Automatically increments build number
- Uploads to TestFlight for testing
- Skips submission to App Store Review

### App Store Release (Manual)
- Run `fastlane release` locally
- Prompts for version number
- Increments build number
- Submits for App Store Review
- Creates git tag

## 🔍 Code Quality

### SwiftLint Rules
The pipeline includes SwiftLint with these configurations:
- **Line Length**: Warning at 120, Error at 200
- **Function Length**: Warning at 50, Error at 100
- **Type Length**: Warning at 300, Error at 500
- **File Length**: Warning at 500, Error at 1000

### TODO Comment Detection
The pipeline fails if it finds:
- `TODO` comments
- `FIXME` comments
- `HACK` comments

## 🚨 Troubleshooting

### Common Issues

1. **Build Fails**
   - Check Xcode project configuration
   - Verify all dependencies are properly configured
   - Check for syntax errors

2. **Code Signing Issues**
   - Verify certificates repository is accessible
   - Check Match configuration
   - Ensure GitHub secrets are correctly set

3. **TestFlight Upload Fails**
   - Verify App Store Connect API credentials
   - Check app identifier matches
   - Ensure app is properly configured in App Store Connect

### Debugging
- Check GitHub Actions logs for detailed error messages
- Run Fastlane commands locally to debug issues
- Verify all environment variables are set correctly

## 📈 Monitoring

### GitHub Actions Dashboard
- Monitor workflow runs in the Actions tab
- View detailed logs for each step
- Check for failed builds and tests

### TestFlight
- Monitor build processing in App Store Connect
- Check for build validation issues
- Track internal testing progress

## 🔐 Security

### Secrets Management
- All sensitive data is stored in GitHub Secrets
- Certificates are stored in a private repository
- API keys are encrypted and secure

### Best Practices
- Never commit secrets to the repository
- Use App Store Connect API keys instead of Apple ID passwords
- Regularly rotate certificates and keys
- Monitor for security vulnerabilities

## 📚 Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftLint Documentation](https://github.com/realm/SwiftLint)

## 🤝 Support

For issues with the CI/CD pipeline:
1. Check the troubleshooting section above
2. Review GitHub Actions logs
3. Test locally with Fastlane commands
4. Consult the documentation links above 