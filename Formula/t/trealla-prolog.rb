class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.13.25.tar.gz"
  sha256 "d147ad8c08b6358f810841389778a45b8e8e3b522fd60185c87ae0aad8ee0a9e"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "89edbac38d6e55675f9bdb44360eda68101bc481dc742dd9daffac83d8ed12a1"
    sha256 arm64_tahoe:       "61c4a478d894e128a9b85aff5e698daba71c8f799a63386c08402dd432796c2e"
    sha256 arm64_sequoia:     "347acd92bee477c889531cf6863e5c6fe9924281d53e5634ce6fffd78704af03"
    sha256 arm64_linux:       "d3effcbc8387546f642e2f63846f19670bed61804ee830de6a66c8bc558ad861"
    sha256 x86_64_linux:      "b2199636bc50ea77288ff7723d37012f8b38fb7dbcbd13fb72e5a4ae211095fc"
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
