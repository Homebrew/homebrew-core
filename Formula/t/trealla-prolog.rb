class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.51.tar.gz"
  sha256 "abbd6d4cf85fdc13b27ce7b074b4f63eca7015cdc2b19c728d6e8aecfaf5c292"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "697469bea6c21fcc1d26c4535b651e58ed5ba6ac42db37cc11e694e3606d73c2"
    sha256 arm64_tahoe:       "b1e1c9c3f3cb79ddd121149c5c15ef7c4185f210c0284587fc913828d53ae50f"
    sha256 arm64_sequoia:     "935e14f9c7b697091f8da6720632cdd39dadf2c47c99f8980379f2ad3eef0868"
    sha256 arm64_linux:       "f81b495732f5c668d83059d32dda1433686ae3fefd7294478e6fd9e65e7224bf"
    sha256 x86_64_linux:      "7671481593fd0003ab19bb56fb36c63b0f34f1627318ce240773658acf0c75ab"
  end

  depends_on "openssl@4"

  uses_from_macos "libedit"
  uses_from_macos "libffi"

  deny_network_access!

  def install
    args = ["PREFIX=#{prefix}", "OPENSSL=openssl@4"]
    # macOS keeps ffi.h in an ffi/ subdirectory, which the build's plain
    # `#include <ffi.h>` misses. TARGET_CFLAGS is the makefile's append hook.
    args << "TARGET_CFLAGS=-I#{MacOS.sdk_path}/usr/include/ffi" if OS.mac?
    system "make", "install", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpl --version")

    assert_equal "42", shell_output("#{bin}/tpl -g 'X is 6*7, write(X), halt'").chomp

    # library(assoc) is not embedded in the binary, so this also proves the
    # installed library path was baked in correctly.
    goal = "use_module(library(assoc)), list_to_assoc([a-1, b-2], A), " \
           "get_assoc(b, A, V), write(V), halt"
    assert_equal "2", shell_output("#{bin}/tpl -g '#{goal}'").chomp
  end
end
