class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.54.tar.gz"
  sha256 "994669b113e6fe236d5c2a0de1a663e2595f7707f1fa16878fc6f779bdd1d306"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "ad30d0c121170c74f872bba8f23b0c28b7ab8efcc1fe44717cff8f0fa21b27bc"
    sha256 arm64_tahoe:       "56ef3fb85710f917d63a22a0c5692d5f144648db9f9d7cc8717b2fe42f48df4a"
    sha256 arm64_sequoia:     "db6e28109fc9256ce6d8c5e5b472a1858541d673509070624d560928ac013aba"
    sha256 arm64_linux:       "5b531f10eac91d912aae0bc3d46abd502386dc6f0b8839b320c78bbcc413008e"
    sha256 x86_64_linux:      "2086056a87022b6c48bca35a0868eff2395b61f2afa7874e8662d0869d953f1e"
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
