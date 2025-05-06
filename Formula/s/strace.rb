class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.14/strace-6.14.tar.xz"
  sha256 "244f3b5c20a32854ca9b7ca7a3ee091dd3d4bd20933a171ecee8db486c77d3c9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "418663fec63512fa8d45f4a0f6612cf8feca14d5a9796b2815c119b0d6ff790b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "335c9c43ed7b79bf4c441ddabeaa802224dc3f03af94cb760d172937a3e2eda9"
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
