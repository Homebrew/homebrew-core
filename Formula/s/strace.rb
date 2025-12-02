class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.17/strace-6.17.tar.xz"
  sha256 "0a7c7bedc7efc076f3242a0310af2ae63c292a36dd4236f079e88a93e98cb9c0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2605dc7f27f7774008e3cd7cdf12a67e986de00d103bff1acc2d008c55c5f3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc9dd34f25bbd09b7608053eccb787add86d50049218f9c2c4120735339cc549"
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
