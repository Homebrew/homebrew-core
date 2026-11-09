class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.64.tar.gz"
  sha256 "c5e6956e774f64c8186d0bee2fe9bb60e91ad6bb52aa2346277135d2e64be918"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "2e7bd723a242cd842938562ddbf22ec2288460e7213656971fd04ab6d774ca74"
    sha256 arm64_tahoe:       "60100de17a76e9adf4bd50bfde3a4c23b26d222bc28c28ca8368f4d4a909b224"
    sha256 arm64_sequoia:     "9f829034da7712c3da39c5a7e2e54f1a39079819ec4012c416729718ea4fd332"
    sha256 arm64_linux:       "30d1ad99c1e1ecae161f8bfa839b1fa29e85b552d8df6f9f421e1bf3842cd401"
    sha256 x86_64_linux:      "08c19970df16ee2aeddb56190ff82e3806558362429f65a0264065f9d04fb4b3"
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
