class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.46.tar.gz"
  sha256 "d4f1453806c6f832e60cba20f8e26a7d095e392d78869508bd143532ece763db"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "a76738bb28f89cff39da15a2432246f714af11fd6021edaac33ef66b5b4e03b4"
    sha256 arm64_tahoe:       "3444dc952a935fbac4c50db3ae6502bac15a471c19521c69b9978e8d10e315ed"
    sha256 arm64_sequoia:     "41a6557a4f4be2f9367ccd8ceb3dbb9e657edeaafef4add4152f79849a3581bd"
    sha256 arm64_linux:       "0a4ce0430f86100f17a49f72158a2528b2fc87c200ab960d8197bfffb132d122"
    sha256 x86_64_linux:      "8bc9e4d2474a95c61818ec996a9a85ea2225e63e1741f4ed205fb18d3da8a126"
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
