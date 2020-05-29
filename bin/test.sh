#! /usr/bin/env bash

XCODE_SCHEME=$1
OUTPUT_DIR="Build/$XCODE_SCHEME"

mkdir -p "$OUTPUT_DIR"

# needed for code coverage
TEST_BUNDLE_PATH="$OUTPUT_DIR/tests-bundle.xcresult"
rm -rf "$TEST_BUNDLE_PATH"

bin/configure.sh

set -o pipefail && \
xcrun xcodebuild test \
    -workspace Multisig.xcworkspace \
    -scheme "$XCODE_SCHEME" \
    -destination "platform=iOS Simulator,name=iPhone 11 Pro" \
    -resultBundlePath "$TEST_BUNDLE_PATH" \
| tee "$OUTPUT_DIR/xcodebuild-test.log" | xcpretty -c -r junit

# print the total code  coverage
xcrun xccov view --report --only-targets "$TEST_BUNDLE_PATH"

# archive the test results
tar -czf "$TEST_BUNDLE_PATH".tgz "$TEST_BUNDLE_PATH"

# codecov does not support new Xcode coverage format (Test Plan) for now.
# curl -s https://codecov.io/bash | bash -s -- -D "$TEST_BUNDLE_PATH" -t "${CODECOV_TOKEN}"
