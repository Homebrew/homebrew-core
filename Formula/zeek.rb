class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.0.1",
      :revision => "ae4740fa265701f494df23b65af80822f3e26a13"
  revision 1
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "233d19bca338125089a16a92c53fb54f0f636ae17f7f39cef981f70cd7c3f629" => :catalina
    sha256 "7f014b23ca0d4bdb37160bafbe03cc41dda956f494d8231d454e6f25f6bae4a9" => :mojave
    sha256 "0ebc2e0c6e774ad3f7f22e8756ebe2afff1e1aab2933e93e64d7459e85ce54c8" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-caf=#{Formula["caf"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-broker-tests",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/zeek", "--version"
  end
end
