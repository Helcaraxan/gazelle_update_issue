load("@io_bazel_rules_go//go:def.bzl", "go_binary")

def my_macro(name):
    go_binary(
        name = name + "_macro",
        embed = [":go_default_library"],
        visibility = ["//visibility:public"],
    )
