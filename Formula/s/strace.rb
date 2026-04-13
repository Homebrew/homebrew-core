class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.19/strace-6.19.tar.xz"
  sha256 "e076c851eec0972486ec842164fdc54547f9d17abd3d1449de8b120f5d299143"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f62141e40b16421c2670fe54d40dca1144226058b247e341d66f82d40ed425e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa3032d5b83560f504e2d961df94ccca05c77f9a2447f2cae0316a98b1d65f6d"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-mpers=no", # FIX: configure: error: Cannot enable m32 personality support
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
