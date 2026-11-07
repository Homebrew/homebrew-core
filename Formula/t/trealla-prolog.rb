class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.55.tar.gz"
  sha256 "995051cee2c22425a4cff60b12ed04d79c5dfbd49ba79749348c834e14a4ac59"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "43a7441b6453cb0805395e541471447ba715fb3402913cd8f43c94a8e313dbc5"
    sha256 arm64_tahoe:       "b55d520947b1ea23c422da3cd47c83555e3aa5c9046ad8d05b48f409c8ba92be"
    sha256 arm64_sequoia:     "8b4b9662b0d775e2f8325867769a1559c662461ec4515b83bd19d899d16d612e"
    sha256 arm64_linux:       "85d65fd5a094676cc780fd1a9f367295247c1b2cf96eb1480c0722742bece22a"
    sha256 x86_64_linux:      "05948d1d08bce3cf2e934f1fdd0081f050ab98444fcc756ad1fdae52d004d732"
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
