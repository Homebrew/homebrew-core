class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.15.tar.gz"
  sha256 "9d1d9cd6f815bcb6814007c90a6cf8b819da083416f2c0acbd9edcf06847d8d1"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "b2c94fec1d729a106918329b92428d5fff95440affa82642e0a694cfd45d225d"
    sha256 arm64_tahoe:       "51f1652585f55684a090ac2c01a3d100e2bdb93e3ef93c4eac7e284a95b94eb1"
    sha256 arm64_sequoia:     "9009055ec0df19d48eeeea4d0566128145b945806436ebcef46baf80d98e1d98"
    sha256 arm64_linux:       "0dc854b1eb8d5478c26c810976909cc1e24eb66c06293342ba79831795dc3682"
    sha256 x86_64_linux:      "5be252121492380536e9598186bff7fa5083106a2f08e8841dc4738f52e3a270"
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
