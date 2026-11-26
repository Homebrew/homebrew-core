class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.45.tar.gz"
  sha256 "4dbca8f9a857b049c3ee1b884daaeb3eb9a5727a7d5ba75ba1a1067721ebef1f"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "db8a5da6bb377d5c2e56dd0f2707b26eeb0e500f204705ade96f0855c64efbaa"
    sha256 arm64_golden_gate: "615d020e6bbf1edf3c57f8f153c47993635a627337b6a305c58585f437713ead"
    sha256 arm64_tahoe:       "a67648b4ec8b3ee4763ed13ff4127a3721fe3b477617fef38630ebaac361e98c"
    sha256 arm64_sequoia:     "092abf29f3b1650f45a6792f1a8d58d2932f6bc22b09eaf271f505c9e186f86f"
    sha256 arm64_linux:       "580d5c936fa658f2fad191ef4369285b6fc8e69b1daaae22b7e4d5fafdb8a6ca"
    sha256 x86_64_linux:      "2882409c69d9a704601ba88c548a57fd8e3f871cc22566946efb0f84f5423a03"
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
