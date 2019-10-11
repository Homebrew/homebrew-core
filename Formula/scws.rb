class Scws < Formula
  desc "Simple Chinese Word Segmentation"
  homepage "https://github.com/hightman/scws"
  url "http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2"
  sha256 "60d50ac3dc42cff3c0b16cb1cfee47d8cb8c8baa142a58bc62854477b81f1af5"

  bottle do
    cellar :any
    sha256 "4dedb954c6d17b1cc42d41a978e41a897110e042bbd6099f82bdbd0ff86b7aad" => :catalina
    sha256 "feb648d3c6c98b2e693086371dae419f88b56b6d58e5ede76ffa882a6f9be4b6" => :mojave
    sha256 "94977ce56fa0c3c9d2fb21fe52067b49be65247b41d723893ac8c91f0e2dbbf3" => :high_sierra
    sha256 "81e6665fd65aae5e35c3e0b3f9f80bdaaf8ac787dfe6fe9e8454a8cb5cbcba02" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/scws -c utf8 -i 人之初")
    assert_match "人 之 初", output
  end
end
