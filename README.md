# Gazelle 0.21.1 to 0.22.0 regression

## Regression description

This repository illustrates a regression between [Gazelle] versions 0.21.x and 0.22.x. It concerns
the appropriate handling of virtual collisions between identically named macro and rule targets
inside Bazel's BUILD files.

Up to release 0.21.x `gazelle` would appropriately parse, handle and update BUILD files that contain
both a rule and a macro with an identical name. Such a virtual collision that is allowed by Bazel
itself, as long as the macro never defines an implicit rule target with the same name.

Starting with `gazelle` 0.22.0 an error is returned:

```text
gazelle: <path>/BUILD.bazel: multiple rules have the name "foo"
```

despite there actually only being one real rule that named "foo" and the other target being a macro.

[Gazelle]: github.com/bazelbuild/bazel-gazelle

## Reproducing the issue

### Setup

* The `rules.bzl` Skylark file defines `my_macro`, a Bazel macro that serves as an indirect way of
  defining a `go_binary` with a name equivalent to the one passed to `my_macro` suffixed with
  `"_macro"`.
* The `main` package contained in this repository defines a simple _Hello World_ program with no
  third-party dependencies. Its `BUILD.bazel` file defines both the usual `go_library` and
  `go_binary` rules generated via `gazelle` following the historic `go_default_library` naming
  pattern. It also defines a `my_macro` target named `main`, just like the `go_binary` one which
  indirectly resolves to a secondary `go_binary` target named `main_macro`.

### Steps

1. Check out the repository and run `bazel run //:gazelle`. This will use Gazelle at version 0.22.2
    and showcase the error of multiple rules named `main`.
1. Go into the `WORKSPACE` file, comment out the dependency on `gazelle` at `v0.22.2` and uncomment
    the previously commented dependency on `gazelle` at `v0.21.1`.
1. Rerun `bazel run //:gazelle` and observe that no error is shown.
