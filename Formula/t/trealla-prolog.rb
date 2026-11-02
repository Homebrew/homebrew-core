class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.42.tar.gz"
  sha256 "f02928f4fc9cf64ebff6068f3ae158c7cba405ce036dc28902150a198537016b"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "3a970331a4bee5478812d6c1349cb5338e4137c9d0df7769e444db3a6a5b2bd7"
    sha256 arm64_tahoe:       "77d917ba3729c45a5a90d9b0f854bca0c55e43af9afdd7a5231a44250b343ede"
    sha256 arm64_sequoia:     "ce1f3fc10db9aebc825d85192bfd6c7bfe5c8fafdc6bccd19c2b46910b7de6e8"
    sha256 arm64_linux:       "21f898273580ed6e8831337360e4cf6f5b3aff6481ea0130c3645a6c3fc759af"
    sha256 x86_64_linux:      "9ed916d9656b6c5e84c5998338e8913ce6f8efe2f9f50fa7f005284d4ca7b21a"
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
