class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.12/strace-6.12.tar.xz"
  sha256 "c47da93be45b6055f4dc741d7f20efaf50ca10160a5b100c109b294fd9c0bdfe"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f45fe32407b8262e3b7c3b52ca47ad9ef5122933823754be62b0886c4273c7c"
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
