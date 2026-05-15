class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v7.0/strace-7.0.tar.xz"
  sha256 "6c92419be3f2ec560b31728a4652217c59864c8642ba7b1b3771b1b013ad074b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b049f883526fec611ca408d5eb4c1685c5d5e17d0b0cde0a797c5df9412963b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c8cc4eada1f33640a27fbce05b51c14a551caeda32fd096eca36c5faf5391d28"
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
