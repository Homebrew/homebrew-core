class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v7.2/strace-7.2.tar.xz"
  sha256 "4bde6246926890dcee824f6e6ac42a06752f47d77e5097d86e3c0d6d4b709fe5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "c34922f79345da9ba1775939017ab18c8a3ee9ae15fee938f8c097674b586bcb"
    sha256 cellar: :any, x86_64_linux: "a22cb25f2744e08e04c4bb5ed6176a13b05cf038bca608e46c73927c2edf0d22"
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
