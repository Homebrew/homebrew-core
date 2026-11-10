class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "8fc1860b666caed358906cbe9580249909a9b668c89f122cf65317b8c166f2da"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "a678a4f643581b40968bd57aebc2729d0f69790a9d209bc229606759c3fc4444"
    sha256 arm64_tahoe:       "bc3a7acf0b9ba3e4c6410e7d2e52635d451e27eac87c53e192f8206d2e78e2e4"
    sha256 arm64_sequoia:     "6e3e6f29561f7d2aa9b5b27a6d869c51c7b746c8a63c5c1fae40372ae9c9cf8d"
    sha256 arm64_linux:       "b06e7b42cda13c162a6a43d758a3c307381b48ea995760b10774fc442b358b0e"
    sha256 x86_64_linux:      "5d4b035b747d1274fa95caca606229b313a7b6f1e7ead5a19bd61ed60edc32af"
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
