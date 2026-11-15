class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.20.tar.gz"
  sha256 "56dd903b70c6ec2b19737c4c3fca54552e7ad8f559a146cbd1b1a9a153278f13"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "942bf92b801061daf77b1e7d70dd148a319705206dc2dbcf0eb6b698b5e3e991"
    sha256 arm64_tahoe:       "af15e61ea4162309e28f6c66e3cbaffc45909480f4229c980e6bc1725493aaa0"
    sha256 arm64_sequoia:     "6f562ac50b339d84b595b5ca6a11e721091f42dfe181d4549f851eb3f5c0a9af"
    sha256 arm64_linux:       "c4212310b4e19ac3ef8c09329d06d103601066c0b0ca15a184af49740a4eb631"
    sha256 x86_64_linux:      "7e920f2312fbf76a30c7352d7fe556499fb05a62ea6c6f33e0fe869dab7d351d"
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
