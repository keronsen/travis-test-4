
set -e


## Clean

rm -rf Build

mkdir -p Build/appstax-ios


## Build framework

cd Appstax
xcodebuild build -configuration Release -scheme AppstaxUniversal SYMROOT="../Build/xcodebuild" $CODE_SIGN_IDENTITY_PARAM #> ../Build/xcodebuild.log
cd -

cp -a Build/xcodebuild/Release-universal/Appstax.framework Build/appstax-ios/Appstax.framework


## Build examples and starterprojects (verify that they compile OK)

cd Examples/Notes
xcodebuild build -configuration Release -sdk iphoneos        $CODE_SIGN_IDENTITY_PARAM #> /dev/null
xcodebuild build -configuration Debug   -sdk iphonesimulator $CODE_SIGN_IDENTITY_PARAM #> /dev/null
cd -
cd StarterProjects/Basic
xcodebuild build -configuration Release -sdk iphoneos        $CODE_SIGN_IDENTITY_PARAM #> /dev/null
xcodebuild build -configuration Debug   -sdk iphonesimulator $CODE_SIGN_IDENTITY_PARAM #> /dev/null
cd -


## Copy to Build/appstax-ios

cp -a StarterProjects Build/appstax-ios/StarterProjects
cp -a Examples        Build/appstax-ios/Examples
rm -rf Build/appstax-ios/Examples/Notes/Appstax.framework
rm -rf Build/appstax-ios/StarterProjects/Basic/Appstax.framework
cp -a Build/appstax-ios/Appstax.framework Build/appstax-ios/Examples/Notes/Appstax.framework
cp -a Build/appstax-ios/Appstax.framework Build/appstax-ios/StarterProjects/Basic/Appstax.framework


## ZIP

cd Build
zip -rq appstax-ios.zip appstax-ios
cd -

