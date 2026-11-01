class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.35.tar.gz"
  sha256 "4fdf3eddf9de5b1f3507f525d812773bae73b2bdf30dca8d1586824769f7aada"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "47b49db3fa84e4eaadc8480c7fcf8812b88e5144aa6315cf474082af8a07f2ab"
    sha256 arm64_tahoe:       "63cfacf02fbda6d38831ee0ad565fe97a2b40ebb81b48843656c3a1620051876"
    sha256 arm64_sequoia:     "0adea3c7cd49643d6f5193c0d29d2d7e08d842a1e0e7f56f788efc5e030f308f"
    sha256 arm64_linux:       "c0190d76fd6b8a09d4286facf47b6e6e10e9bec5c11719b3ad37b19e0aca615d"
    sha256 x86_64_linux:      "df67ad63262f05f08da3505de545dcddf197807f662327427e3d29ab615a8016"
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
