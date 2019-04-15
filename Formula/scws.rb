class Scws < Formula
  desc "Simple Chinese Word Segmentation"
  homepage "https://github.com/hightman/scws"
  url "http://www.xunsearch.com/scws/down/scws-1.2.1.tar.bz2"
  sha256 "74c8ec26882c3b92c6655b552bcf678a56cbcda5fc03b5a0aab08a3cc9fbf588"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scws", "-h"
  end
end
