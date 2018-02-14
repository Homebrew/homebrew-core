class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.5.tar.gz"
  sha256 "16f1566f4507ba560c7461cc7ff1c1653beb14b8baf7846269bbb4880564e57f"

  bottle do
    sha256 "c922408522d0a44e37d24a6e76d9ad50ec78cdae2e4bdcac157eccf2f0bc1ee1" => :high_sierra
    sha256 "84e4895d9674dde107d145b618e064923e2e473cdfc2b6258cddf7c982a014d5" => :sierra
    sha256 "8a23ddb8172c6e882e525262aba6f1074dd67d2fd8a051adc27db843b1c3ca35" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
