class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://www.zeek.org/downloads/zeek-3.0.0.tar.gz"
  sha256 "b552940a14132bcbbd9afdf6476ec615b5a44a6d15f78b2cdc15860fa02bff9a"
  head "https://github.com/zeek/zeek.git"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/zeek", "--version"
  end
end
