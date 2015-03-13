#!/bin/sh

# Decrypt 
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in Scripts/Profile/$PROFILE_NAME.mobileprovision.enc -d -a -out Scripts/Profile/$PROFILE_NAME.mobileprovision
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in Scripts/Cert/dist.cer.enc -d -a -out Scripts/Cert/dist.cer
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in Scripts/Cert/dist.p12.enc -d -a -out Scripts/Cert/dist.p12

# Create a custom keychain
security create-keychain -p travis ios-build.keychain

# Make the custom keychain default, so xcodebuild will use it for signing
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p travis ios-build.keychain

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

# Add certificates to keychain and allow codesign to access them
security import ./Scripts/Cert/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Scripts/Cert/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Scripts/Cert/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign


# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "./Scripts/Profile/$PROFILE_NAME.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
