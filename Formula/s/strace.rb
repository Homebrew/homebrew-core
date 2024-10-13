class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.11/strace-6.11.tar.xz"
  sha256 "83262583a3529f02c3501aa8b8ac772b4cbc03dc934e98bab6e4883626e283a5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac6020a7aeb838b439b2a3c1caeca923c313255f575d95a5f404d8af54d6ac5b"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "glibc"
  depends_on :linux
  depends_on "linux-headers@5.15"

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
