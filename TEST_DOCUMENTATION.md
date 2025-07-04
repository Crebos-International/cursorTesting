# Test Documentation for CusrsorTesting iOS App

This document provides comprehensive information about running tests for the CusrsorTesting iOS app, including unit tests, UI tests, and BrowserStack integration.

## 📋 Test Overview

### Test Categories
1. **Unit Tests**: Test individual components and business logic
2. **UI Tests**: Test user interface and user flows
3. **Integration Tests**: Test component interactions
4. **Performance Tests**: Test app performance metrics

### Test Coverage
- ✅ Authentication (Sign In/Sign Up/Sign Out)
- ✅ Cart Management (Add/Remove/Update quantities)
- ✅ Favorites Management (Add/Remove/Toggle)
- ✅ Product Search and Filtering
- ✅ Profile Management
- ✅ Navigation Flows
- ✅ Form Validation
- ✅ Error Handling

## 🧪 Unit Tests

### AuthManagerTests
Tests authentication functionality including:
- Sign in with valid/invalid credentials
- Sign up with new/existing users
- User profile updates
- Loading states
- Error handling

**Run locally:**
```bash
# Run all AuthManager tests
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:CusrsorTestingTests/AuthManagerTests

# Run specific test
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:CusrsorTestingTests/AuthManagerTests/testSignInWithValidCredentials
```

### CartManagerTests
Tests cart functionality including:
- Adding/removing items
- Quantity management
- Price calculations (subtotal, tax, total)
- Sale price handling
- Edge cases

**Run locally:**
```bash
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:CusrsorTestingTests/CartManagerTests
```

### FavoritesManagerTests
Tests favorites functionality including:
- Adding/removing favorites
- Toggle functionality
- Filtering by gender/category
- Clear all favorites

**Run locally:**
```bash
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:CusrsorTestingTests/FavoritesManagerTests
```

## 🖥️ UI Tests

### CusrsorTestingUITests
Comprehensive UI tests covering:
- Authentication flows
- Navigation between screens
- Cart functionality
- Favorites management
- Search and filtering
- Profile editing
- Performance metrics

**Run locally:**
```bash
# Run all UI tests
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:CusrsorTestingUITests

# Run specific UI test
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -only-testing:CusrsorTestingUITests/testSignInWithValidCredentials
```

## 🌐 BrowserStack Integration

### Setup

1. **Install BrowserStack CLI:**
```bash
npm install -g browserstack-cli
```

2. **Configure credentials:**
```bash
browserstack config --username YOUR_USERNAME --access-key YOUR_ACCESS_KEY
```

3. **Upload your app:**
```bash
browserstack app upload CusrsorTesting.ipa
```

4. **Upload test suite:**
```bash
browserstack test-suite upload CusrsorTestingUITests.xctest
```

### Configuration

Update `browserstack.json` with your credentials:
```json
{
  "auth": {
    "username": "YOUR_BROWSERSTACK_USERNAME",
    "access_key": "YOUR_BROWSERSTACK_ACCESS_KEY"
  },
  "app": "bs://YOUR_APP_ID",
  "testSuite": "bs://YOUR_TEST_SUITE_ID"
}
```

### Running Tests on BrowserStack

```bash
# Run tests on all configured devices
browserstack test run browserstack.json

# Run specific test
browserstack test run --test-name "testSignInWithValidCredentials" browserstack.json

# Run tests on specific device
browserstack test run --device "iPhone 15" browserstack.json
```

## 🚀 CI/CD Integration

### GitHub Actions

The CI/CD pipeline automatically runs tests:

```yaml
# From .github/workflows/ci.yml
- name: Run tests
  run: |
    cd CusrsorTesting
    xcodebuild -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' test
```

### Fastlane Integration

```bash
# Run tests via Fastlane
fastlane test

# Run tests on multiple simulators
fastlane test_devices
```

## 📊 Test Reports

### Local Reports
Test results are saved to:
```
CusrsorTesting/build/reports/
```

### BrowserStack Reports
- Real-time test execution
- Video recordings
- Device logs
- Network logs
- Screenshots on failure

## 🔧 Test Configuration

### Simulator Configuration
```bash
# List available simulators
xcrun simctl list devices

# Create custom simulator
xcrun simctl create "Custom iPhone 15" "iPhone 15" "iOS17.0"

# Boot simulator
xcrun simctl boot "Custom iPhone 15"
```

### Test Environment Variables
```bash
# Set test environment
export TEST_ENVIRONMENT="staging"
export TEST_USER_EMAIL="test@example.com"
export TEST_USER_PASSWORD="testpassword123"
```

## 🐛 Debugging Tests

### Local Debugging
```bash
# Run tests with verbose output
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -verbose

# Run tests with debugger
xcodebuild test -workspace CusrsorTesting.xcworkspace -scheme CusrsorTesting -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' -debug
```

### BrowserStack Debugging
- Enable `"debug": true` in browserstack.json
- View real-time logs in BrowserStack dashboard
- Use BrowserStack's debugging tools

## 📱 Device Matrix

### iOS Simulators (Local)
- iPhone 15 (iOS 17)
- iPhone 14 (iOS 16)
- iPhone 13 (iOS 15)
- iPad Pro 12.9 (iOS 17)

### Real Devices (BrowserStack)
- iPhone 15 (iOS 17)
- iPhone 14 (iOS 16)
- iPhone 13 (iOS 15)
- iPad Pro 12.9 2022 (iOS 17)

## 🎯 Test Scenarios

### Authentication Scenarios
1. **Valid Sign In**: Use demo credentials
2. **Invalid Sign In**: Wrong email/password
3. **Sign Up**: New user registration
4. **Sign Out**: Logout functionality

### Cart Scenarios
1. **Add to Cart**: Add single/multiple items
2. **Update Quantity**: Increase/decrease quantities
3. **Remove from Cart**: Remove individual items
4. **Clear Cart**: Remove all items
5. **Price Calculation**: Verify totals

### Favorites Scenarios
1. **Add to Favorites**: Heart button functionality
2. **Remove from Favorites**: Unfavorite items
3. **Favorites View**: Display saved items
4. **Clear All**: Remove all favorites

### Search & Filter Scenarios
1. **Product Search**: Search by name/description
2. **Category Filter**: Filter by product category
3. **Gender Filter**: Filter by men/women/unisex
4. **Combined Filters**: Multiple filter combinations

### Profile Scenarios
1. **View Profile**: Display user information
2. **Edit Profile**: Update user details
3. **Form Validation**: Required field validation
4. **Image Upload**: Profile photo management

## 📈 Performance Metrics

### Launch Performance
- App launch time
- Memory usage
- CPU usage

### UI Performance
- Screen load times
- Animation smoothness
- Memory leaks

### Network Performance
- API response times
- Data loading
- Error handling

## 🔒 Security Testing

### Input Validation
- SQL injection prevention
- XSS prevention
- Input sanitization

### Authentication Security
- Password strength
- Session management
- Token handling

## 📝 Best Practices

### Test Organization
- Group related tests together
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### Test Data
- Use consistent test data
- Clean up after tests
- Avoid hardcoded values

### Error Handling
- Test error scenarios
- Verify error messages
- Test edge cases

### Performance
- Keep tests fast
- Use appropriate timeouts
- Monitor resource usage

## 🆘 Troubleshooting

### Common Issues

1. **Simulator Not Found**
```bash
# Reset simulator list
xcrun simctl shutdown all
xcrun simctl erase all
```

2. **Test Timeouts**
```bash
# Increase timeout in test
wait(for: [expectation], timeout: 5.0)
```

3. **UI Element Not Found**
```bash
# Add accessibility identifiers
.accessibilityIdentifier("unique-id")
```

4. **BrowserStack Connection Issues**
```bash
# Check credentials
browserstack config --list

# Test connection
browserstack test-status
```

### Getting Help
- Check BrowserStack documentation
- Review Xcode test documentation
- Check GitHub Actions logs
- Contact support team

## 📚 Additional Resources

- [XCTest Framework Documentation](https://developer.apple.com/documentation/xctest)
- [BrowserStack iOS Testing](https://www.browserstack.com/ios-testing)
- [Fastlane Testing](https://docs.fastlane.tools/actions/run_tests/)
- [GitHub Actions iOS](https://docs.github.com/en/actions/guides/building-and-testing-swift) 