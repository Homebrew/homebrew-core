class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.6.tar.gz"
  sha256 "0d1ba56a3ee48595009670e2073160c4e1ffe4eb404c8614deaaaa1db3431a2a"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "377827a4ad0d41b46408a2ee4bacabe7b890c53a506b08255cdc91cc0ac0aa59"
    sha256 arm64_tahoe:       "9c041a1fdae14c819f7b7d4b260deb13b0c408a963a788377de62b0b5746f31d"
    sha256 arm64_sequoia:     "16b8b6ecb377ae235dfe2d8169b8cbc9eaac61f6f527c9e3d78a6abf586646a7"
    sha256 arm64_linux:       "2a07b0c9e677d0086bfe09f5dec18181431fe7a4f6112705269e959e5cd63024"
    sha256 x86_64_linux:      "578a91541cc8f724da42bb1d8bb48086abb7ea7bff25f20556d7ebd1d289bbb6"
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
