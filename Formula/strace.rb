class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v5.19/strace-5.19.tar.xz"
  sha256 "aa3dc1c8e60e4f6ff3d396514aa247f3c7bf719d8a8dc4dd4fa793be786beca3"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "938a66a86d6392a261e2feb0c533310fd3bb2f5b26ed504b1fd40c73cd7d069b"
  end

  head do
    url "https://github.com/strace/strace.git"
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
