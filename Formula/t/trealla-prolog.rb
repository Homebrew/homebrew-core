class TreallaProlog < Formula
  desc "Compact and efficient ISO Prolog interpreter written in plain old C"
  homepage "https://github.com/trealla-prolog/trealla-prolog"
  url "https://github.com/trealla-prolog/trealla-prolog/archive/refs/tags/v3.14.64.tar.gz"
  sha256 "c5e6956e774f64c8186d0bee2fe9bb60e91ad6bb52aa2346277135d2e64be918"
  license "MIT"
  head "https://github.com/trealla-prolog/trealla-prolog.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "ee3939360e873bfbee8362a95949c28a51465827654f30bf7b0674956dee2b15"
    sha256 arm64_tahoe:       "27e3e9c13c1d556bb66caee574237d8eb054f93b557c27d03e21e7be6f76c6fb"
    sha256 arm64_sequoia:     "8e72e9aeb9ccd1fc9ea30bb035416a0f6a33be0be74c8fe29049980da58081e8"
    sha256 arm64_linux:       "bba8039d5d5c636117a76d7b7cfcc25152f113519ffc05f8341f409bf7b087e7"
    sha256 x86_64_linux:      "13708e3013001c021c2a15360227e1289db5259036dc67d1ac46c35c65ad2a46"
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
