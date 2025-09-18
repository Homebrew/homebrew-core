class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.16/strace-6.16.tar.xz"
  sha256 "3d7aee7e4f044b2f67f3d51a8a76eda18076e9fb2774de54ac351d777d4ebffa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "5902682b5e877fadeb346fe27c98342195ddfe9d132ad28b82f6bcdf6bd41b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "90afa938bbcf45ac66d3dcf979a7a1664065fd82d782b7a1b7e7ca941953e488"
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
