class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.12.5.tar.gz"
  sha256 "4d51c7100adb27d0378945f597ac1eb49dd6ecb11ace75bce08802bc54f8ab32"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "144d1f9e952f469b02bd1d6fb04a1efad0dfe7be4c8060e092ff855623088ff3"
    sha256 arm64_tahoe:       "c4a1ed7d18d45b8bf6054210f6352fc4c228b9175ab7f9394dd830f289ca6227"
    sha256 arm64_sequoia:     "b871d367dd626d808b710d7ce04322dbccd04a9f6c6229d0d319ed9a8213c1f7"
    sha256 arm64_linux:       "e181f51362daf82e4384abac894d3001e11bb8225a83e9eb690875530fd7556f"
    sha256 x86_64_linux:      "80424480fa0743261c33836822fe3f666f0b1339c7b8ff5a22cee52224bdcfc5"
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
