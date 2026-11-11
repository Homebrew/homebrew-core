class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "6e02a8e96169b9088c9197239bc2d7257fd238abd653a6107d638895855ba0f3"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "02536f4be4949a6c8f0cfa822cfd5c35ecfc7a5303e264c026976e3e0d1185f5"
    sha256 arm64_tahoe:       "9325827cf0daed4a28ede219194d70cdece866e7f2fed59d89378d2bef74d6d7"
    sha256 arm64_sequoia:     "aa822d3beb53b5e72ceb3369a6471c573130f593f56b464a3c9e76eb32abb75e"
    sha256 arm64_linux:       "d7d98ce0c0974b647d579ecb7aef369273a05c276592775ad7db472ef0225d4f"
    sha256 x86_64_linux:      "1d28248fb82fe32940434fdfaa8ad79092904c9c677a396aa638a91863e6fcc0"
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
