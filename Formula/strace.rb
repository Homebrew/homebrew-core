class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v5.14/strace-5.14.tar.xz"
  sha256 "901bee6db5e17debad4530dd9ffb4dc9a96c4a656edbe1c3141b7cb307b11e73"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ab74131ded479cb7685c0505cd86d60e9ddc9ff10bb8a9c68d710debd7bc54cf"
  end

  head do
    url "https://github.com/strace/strace.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux
  depends_on "linux-headers@4.4"

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
