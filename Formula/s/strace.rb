class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.9/strace-6.9.tar.xz"
  sha256 "da189e990a82e3ca3a5a4631012f7ecfd489dab459854d82d8caf6a865c1356a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a82ad866e58a286bd1234e3ab2d0f701bf97df25102bf5d13a42f97e5d0508b"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux
  depends_on "linux-headers@5.15"

  def install
    system "./bootstrap" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--enable-mpers=no" # FIX: configure: error: Cannot enable m32 personality support
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
