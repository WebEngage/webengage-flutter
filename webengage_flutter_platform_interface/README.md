# webengage_flutter_platform_interface

A common platform interface for the WebEngage Flutter plugin.  
This package defines the shared API contract that all WebEngage Flutter
platform implementations must follow.

---

## Overview

`webengage_flutter_platform_interface` is part of the **WebEngage Flutter SDK**
federated plugin architecture.

It contains:
- Abstract classes and method definitions
- Shared data models and enums
- Platform-agnostic API contracts

This package **does not contain any platform-specific code** and is **not meant
to be used directly by Flutter applications**.

---

## Architecture

This package is used by the following WebEngage Flutter plugins:

- `webengage_flutter` (main plugin)
- `webengage_flutter_android`
- `webengage_flutter_ios`
- `webengage_flutter_web`

