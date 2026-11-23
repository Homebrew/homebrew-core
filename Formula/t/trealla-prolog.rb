class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.15.31.tar.gz"
  sha256 "fef593e739fcba11be356931c227c7b316fe98bb7bfe8adbce814194d491fc68"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "41013d778c1f8f3c34cf63cec3faf7ace7704f378606b6ccff605f843cee67f5"
    sha256 arm64_golden_gate: "1ed97cd5f3b2959e655909121f4e66f7e1afd9db9e4661c34c6e77dc40e33f20"
    sha256 arm64_tahoe:       "ae7ca2b8e0afd0b0263eff343b64786fe8255fc0278ace71e0028ac07554d8ba"
    sha256 arm64_sequoia:     "30350761f8fcde4bf4457d2d0be2693029463c4ec296dc526ef6ea5028621eef"
    sha256 arm64_linux:       "5d26e68c176a4d0813602a1401e37a24ea66c670838bd980953e5f46b83a4663"
    sha256 x86_64_linux:      "d49ac7ac519272de461de077ec1582b38217d49c1e86a7308a16a16228108155"
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
