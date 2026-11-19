# Security policy

## Supported versions

Security fixes go into the latest 1.x release.

## Reporting a vulnerability

Please do not open a public issue. Report it privately instead:

- Use GitHub's [private vulnerability reporting](https://github.com/AlexanderTar/LASwift/security/advisories/new), or
- email taraymovich@me.com.

Include the LASwift version, the platform, and a minimal piece of code that shows the
problem. Expect a first reply within a week. Once a fix is released, the report is
credited in the release notes unless you prefer otherwise.

LASwift is a numerical library with no network or file access. Typical reports are memory
safety bugs, such as out-of-bounds reads or writes on malformed input.
