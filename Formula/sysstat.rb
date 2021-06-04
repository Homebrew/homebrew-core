class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/v12.5.3.tar.gz"
  sha256 "49fa6e4ce4994186d34f20cad43032be411d3f98244cbd8c3d3c480c3a4535bc"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git"

  depends_on :linux

  def install
    system "./configure",
           "--disable-file-attr", # Fix install: cannot change ownership
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
