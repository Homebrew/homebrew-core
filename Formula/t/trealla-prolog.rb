class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.10.30.tar.gz"
  sha256 "7d3f93af8e5f889aad715b06a19894b51d67f4c3273ea269692235a208250586"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "dfb9c98d058545eaf54ba06b8a54f2a39225b5fa358980f172fc0720f0fce84b"
    sha256 arm64_tahoe:       "bddde54e485cd13b29aacd77f7a3b65257e60a4de25d71b819d6ed1f910d20d5"
    sha256 arm64_sequoia:     "6710bbf443abc41ec41ddcfbbe3972ffa830ae391a9992ef20ab9c455c241be4"
    sha256 arm64_linux:       "78301bdf88d89cca52becc4d9b6fdb7925fdb1d6e2278a86e9839fc891f56155"
    sha256 x86_64_linux:      "e1c788a9d6bcb9730ae8952145866dc89c3a3bb732a035f2ee870d1b09aa55cb"
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
