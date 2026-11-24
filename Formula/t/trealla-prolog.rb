class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.35.tar.gz"
  sha256 "cc6c713299d727074719c661414752be5e3f91a1a87703826c5030d449eab875"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "40d85dcbd001dbd0247e90271a2441e1e9674d04b3e3f0dcba0c8556cc7c4db0"
    sha256 arm64_golden_gate: "f05cf9b2d4d6e730e3dc3b3d2e8144768139f56bc870875d2baf03dc05689a79"
    sha256 arm64_tahoe:       "0bcc442f320bdc569e0eb18be17c7d6f5b9fad6347cb4b3c0d6ea6adedc585cd"
    sha256 arm64_sequoia:     "2cf28acbb5747903ef4fb3dd956e1b5380a2231c8c3bc697619a7f92ab7528cb"
    sha256 arm64_linux:       "2dfe358f2db969701d09aa6552da1a9627328a672010a3b67c5741ba510b4344"
    sha256 x86_64_linux:      "5e3dff3b84dd6522899cecd146c324f81c2486c4ab2c330190f065fe9b75dc89"
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
