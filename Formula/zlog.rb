class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.12.tar.gz"
  sha256 "9c6014a3f74d136c70255539beba11f30e1d3617d07ce7ea917b35f3e52bac20"

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end
  
  test do
    system "#{bin}/zlog-chk-conf", "-h"
  end
end
