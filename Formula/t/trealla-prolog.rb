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
    sha256 arm64_golden_gate: "49cda6b506f3cbae98fc7ae2bc6e0745503064f10dbf1829dbcab45ada470f83"
    sha256 arm64_tahoe:       "aa24850c7cf9056b287e574685ff5c065b7551e3c70d93960cbe292d5ff02320"
    sha256 arm64_sequoia:     "5a34e1aab434d7814558d46349e90fafc36f475283b88a157c401d3a2f3adfc5"
    sha256 arm64_linux:       "940e1cb4d797b6bf6915c7e9069b7af7449a96807edff1e35cfced27a23fe239"
    sha256 x86_64_linux:      "03e1b051c2c8579d4deafda673bbfd3002677549c81d688dd9758dbed32b12b0"
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
