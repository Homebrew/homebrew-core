class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.48.tar.gz"
  sha256 "375f6f14b1382cbf01e0680cf1c8a89608252116af55365c0a08735913ca46a6"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "59cbd325acff7af652c90485dc31d40521d97e77547e1afe05fe5d4b88ea5b5c"
    sha256 arm64_golden_gate: "ccba83d8c1e51d6977be91d455350d772fdda5f3360cc63075ac59e7d2143435"
    sha256 arm64_tahoe:       "19059552233719afa92aa0226fb2ff72dd49f6df159ba7d811497e3a5d96c7f2"
    sha256 arm64_sequoia:     "27fd61750cf0fed2c082fdaea6aa9d1615c71d642a763686876544a715046519"
    sha256 arm64_linux:       "755e837ced7ef2ea8d734252f8501f31c606ae7b7b09a6e24d2fa23ccbda1881"
    sha256 x86_64_linux:      "145fb7417ed01fb2d7be2811a8852cd9b4a7b0a0dd3ad8155fb13a709b7c5adf"
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
