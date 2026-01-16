class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.18/strace-6.18.tar.xz"
  sha256 "0ad5dcba973a69e779650ef1cb335b12ee60716fc7326609895bd33e6d2a7325"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "457e32a450269d194053eadfc7030bb8b1c8776cf752401ba6183dbdd11fc91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f822a97f73f2e82857a9467c02bd863d37699982dcd13d9f3d3ec725b2e65f1"
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
