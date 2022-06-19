class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v5.18/strace-5.18.tar.xz"
  sha256 "60293ea79ac9253d600cdc9be077ad2988ca22284a439c9e66be5150db3d1187"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3a8a7c084e8e214f05fe5fc3c3c3008e9fca5e4a430b8db3d56bcda206c9a1ea"
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
