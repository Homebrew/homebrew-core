class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://sysstat.github.io/"
  url "https://github.com/sysstat/sysstat/archive/refs/tags/v12.8.1.tar.gz"
  sha256 "d118a925f53633dbb7cbbefa1ea6a0cdcb1d961ee45617fa2179aa4119c33a40"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "a57bf29f699848fa2520b8246c3d9b0cd725a8c3f3dd4ae2ef50fe09fe727de5"
    sha256 x86_64_linux: "558167ac35a8b5a4b5bbddad619a94dda00565317ff755c9878bf70bbaece9cf"
  end

  depends_on :linux

  deny_network_access!

  def install
    system "./configure",
           "--disable-file-attr", # Fix install: cannot change ownership
           "--disable-automated-sar-reporting",
           "--prefix=#{prefix}",
           "conf_dir=#{etc}/sysconfig",
           "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    assert_match("PID", shell_output("#{bin}/pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}/iostat"))
  end
end
