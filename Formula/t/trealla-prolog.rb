class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.10.tar.gz"
  sha256 "ddfb1e5b50bb54855d9f146dab4f13f0d9f51d02c4dc5a678a0b82d8bdd181bd"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "9ee496a01bebe3e90251d5a9e85ad6eaaf96794d1923dd4864314148e73d1bff"
    sha256 arm64_tahoe:       "173df29fc0b491d675fa6e1c610a2ba285059d4e16091e663fe89f041ca7337b"
    sha256 arm64_sequoia:     "0a91395c63937c83138c3e586df02d7c0d4f7cf330ce750552deb6412e7b27e4"
    sha256 arm64_linux:       "f1efb7410e741cdfca3937798d545a82c4fc8f3a61e2713317647045ebb9baa5"
    sha256 x86_64_linux:      "dc7e5a9b7e1aecd24a34a397bb55470c71c9d5ccd90a331335d201c382b05553"
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
