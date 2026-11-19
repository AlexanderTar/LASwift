//
//  ExitTestSupport.swift
//  LASwift
//
//  Copyright (c) 2017 Alexander Taraymovich <taraymovich@me.com>
//  All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the BSD license. See the LICENSE file for details.
//

import Testing

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

// Exit tests (`#expect(processExitsWith:)`) and AddressSanitizer do not mix: the exit-test
// child is spawned without the ASan runtime preloaded, so it dies with "ERROR: Interceptors
// are not working ... AddressSanitizer is loaded too late" before it reaches the precondition
// under test. Setting DYLD_INSERT_LIBRARIES does not fix it.
//
// Every test that contains an exit test therefore carries the `.exitTests` trait:
//
//     @Test("my precondition", .exitTests)
//     func myPrecondition() async { ... #expect(processExitsWith: ...) ... }
//
// The trait disables the test when the ASan runtime is loaded (`swift test --sanitize=address`)
// and leaves it enabled in a plain `swift test`. A new exit test without the trait fails in
// the CI sanitizer step, which is the guard.

/// Whether this process runs with the AddressSanitizer runtime loaded.
let isAddressSanitizerLoaded: Bool = {
    guard let handle = dlopen(nil, RTLD_NOW) else { return false }
    defer { dlclose(handle) }
    return dlsym(handle, "__asan_init") != nil
}()

extension Trait where Self == ConditionTrait {
    /// Disables a test containing an exit test while AddressSanitizer is loaded.
    static var exitTests: Self {
        .disabled(if: isAddressSanitizerLoaded, "exit tests cannot run under AddressSanitizer")
    }
}
