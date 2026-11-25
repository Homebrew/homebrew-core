class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.40.tar.gz"
  sha256 "dafedf3c91f975af43ff5c3e6e2e7f9cceec555bad1ee4764ed5d185aa81c09e"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "f79931c7a817f028de535943d76829568d2df1c2153c26651912c9b76adfa9e5"
    sha256 arm64_golden_gate: "5561919821e2b21c1d9dda610a5ce52b9c5bedbf8488a1942642fbb6923f6cc6"
    sha256 arm64_tahoe:       "3bf75a7afa2e1928aea6b98705f7db4c391f28eb8a54299d4bb633b0974a8d86"
    sha256 arm64_sequoia:     "ae49f7de70fc8fe114b0c25ee5ca7c19530a6f5bb547e902a2b99d3eb69c4910"
    sha256 arm64_linux:       "c9d0d3efdc3530a84f112faa8ea7e39f8541e30eb24509ee723bfee7c4ff8395"
    sha256 x86_64_linux:      "c5b41a748e76a6acc4bd28694d3e4c870245cbd30a272684bbe2a0bb43deb6e5"
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
