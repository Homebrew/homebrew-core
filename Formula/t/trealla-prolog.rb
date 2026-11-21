class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.22.tar.gz"
  sha256 "e877de5096bbd4b4b32e824edbb676870e4f453321cb7f376d703dc5c2fdbf20"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "01a6ee4296162fffa4458eba23a0ff3efcd15ee27d5176e7e0cadfac26698860"
    sha256 arm64_tahoe:       "e722a35b3e0da6b24c1375eb7c209cc8114d3ad0863bcbabd26c3fa3ce053d73"
    sha256 arm64_sequoia:     "0915027233af0c9bd26df3d7a777f18784cc87d6078bd5a1e936bd96c05e4ef9"
    sha256 arm64_linux:       "94337b0f9fc785ce320b9bf6075f976f0a274984b4342888aa3fdb08af357f1f"
    sha256 x86_64_linux:      "4bbdc18e6f39c583d41d2358bda098d7804b8e43f77e1aa9ce93ec97666b416b"
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
