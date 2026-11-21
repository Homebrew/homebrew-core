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
    sha256 arm64_golden_gate: "62f676928866d3419bc1b51e59dcd87174c3f94b3c475cf451f2090cec4079c7"
    sha256 arm64_tahoe:       "14b3ada3ee76531e6aa7c228899e66dd8b9fc2c735c7d0d2ee03c57be5801cd3"
    sha256 arm64_sequoia:     "639031104a4f23c9e4c5ef37a4f4291bfde708ea43fe75a6522ed1d235dfae30"
    sha256 arm64_linux:       "e1f23ef911790b005bec9731c56f179d5dc57820b7b83a57c2ddfddfc5a8f8c1"
    sha256 x86_64_linux:      "6dc7eccfba7b22ee6a2e08e515d5ac4b2c20277f45b7d915d3fc116d4d8b88b4"
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
