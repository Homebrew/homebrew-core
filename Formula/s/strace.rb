class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v7.3/strace-7.3.tar.xz"
  sha256 "529634c40910895a9a1f3c5c1e65da2ca9ed72fb158dfc4bcc89efdf05e39b72"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "8cad55fb8ea563d24c4a52bbdb4433c651197af9d1d1b4b2cf3179961c06165c"
    sha256 cellar: :any, x86_64_linux: "fe3622f74dcfcc8ee78a3a7efd0b6f0e00540c1e2fe29928e8a1a88be57fef5d"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux

  deny_network_access!

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
