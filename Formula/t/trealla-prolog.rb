class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.46.tar.gz"
  sha256 "5055c2c1719407948b25b752302c659474c1b7ab87b7714439ba9457aa63e21e"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "f1e8dd564f46e0afbe1b4f8ae0ac350101bd6e0bc91b426bccbbcd17a476d68e"
    sha256 arm64_golden_gate: "ec9b1d4bf36d66f206a5d047e30b1596cd529fec6e18af01c8f86c0370b639c0"
    sha256 arm64_tahoe:       "442d28308b7fca4cf35a67b245f2a20fa419aabeaebe55e8f36d32456302b9ae"
    sha256 arm64_sequoia:     "4b036656784aa3d25f362e3b35d357f9a936afb40a83842eb09cd9c042e5ea13"
    sha256 arm64_linux:       "d141a4013e7c77716ee2f257dcc4a9d7cbcf366a422bae9d617e063ee67cfae6"
    sha256 x86_64_linux:      "62d3db55256bc973bc2f57c8f82e8d282f71fb6fc1dc21b33937053085f914db"
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
