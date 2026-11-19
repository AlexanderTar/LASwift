# Contributing to LASwift

Thanks for helping. Please follow the [Code of Conduct](CODE_OF_CONDUCT.md). Report security
problems as described in [SECURITY.md](SECURITY.md), not in a public issue.

## Setup

You need a Mac with Xcode 26 or later (Swift 6.2 tools). LASwift uses Accelerate, so it does
not build on Linux.

```sh
git clone https://github.com/AlexanderTar/LASwift.git
cd LASwift
swift build
swift test
```

## Checks that CI runs

Run these before you open a pull request. They are the commands in
[.github/workflows/ci.yml](.github/workflows/ci.yml).

```sh
swift build
swift test --enable-code-coverage
swift test --sanitize=address
for platform in iOS tvOS watchOS visionOS; do
  xcodebuild build-for-testing -scheme LASwift -destination "generic/platform=$platform" -quiet
done
```

CI compiles the library and the tests for iOS, tvOS, watchOS and visionOS but does not run
the tests there. Before a release,
run the tests on simulators. For example, on iOS:

```sh
xcodebuild test -scheme LASwift -destination "platform=iOS Simulator,name=<a simulator you have>"
```

Use `xcrun simctl list devices available` to find simulator names, and the same pattern with
`tvOS Simulator`, `watchOS Simulator` and `visionOS Simulator`.

To check the documentation catalog builds without warnings:

```sh
xcodebuild docbuild -scheme LASwift -destination "generic/platform=macOS"
```

## Tests

- Tests use [Swift Testing](https://developer.apple.com/documentation/testing) in `Tests/LASwiftTests`.
  Performance benchmarks stay on XCTest in `PerformanceTests.swift`.
- Compare floating-point results with `expectClose` from `Tests/LASwiftTests/Helpers.swift`,
  not `==`.
- Write the test first and watch it fail for the reason you expect.
- **Exit tests need a trait.** A test that checks a precondition with
  `#expect(processExitsWith:)` must carry the `.exitTests` trait
  (see `Tests/LASwiftTests/ExitTestSupport.swift`):

  ```swift
  @Test("my precondition", .exitTests)
  ```

  Under `swift test --sanitize=address` the exit-test child process fails with
  "Interceptors are not working ... AddressSanitizer is loaded too late", and
  `DYLD_INSERT_LIBRARIES` does not help. The trait skips these tests when AddressSanitizer is
  loaded. A new exit test without the trait fails in the CI sanitizer step, which is the guard.
- **Exit tests are macOS and Linux only.** Wrap them in `#if os(macOS) || os(Linux)` (a whole
  suite, or the test functions inside a suite). On iOS, tvOS, watchOS and visionOS
  `#expect(processExitsWith:)` is unavailable and the test target fails to compile. The CI
  `build-for-testing` step for those platforms is the guard.

## Style

- Match the surrounding code. Public functions have `///` doc comments with `- Parameters:` and
  `- Returns:`, and a `precondition` for invalid input.
- Prefer Accelerate (vDSP, BLAS, LAPACK) over hand-written loops. LAPACK goes through the
  `CLASwiftLAPACK` C target.
- Add the user-visible change to `CHANGELOG.md`, and new public symbols to the topic groups in
  `Sources/LASwift/LASwift.docc/LASwift.md`.

## Pull requests

1. Fork the repository and branch from `master`.
2. Keep the change focused: one fix or feature per pull request.
3. Run the checks above, then open the pull request and fill in the template.
4. Sign your commits with GPG.

Dependabot opens weekly pull requests for GitHub Actions updates (and Swift package updates, if any appear). Merge it once CI passes.
