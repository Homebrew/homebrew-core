class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.18.2.tar.gz"
  sha256 "855ce1ce862fc2cb7146a04cbe60ba2584ff7df176e07494a2f14d26976b4c2b"

  bottle do
    sha256 "5bc6286c86c29a9e3004e5023796a7c5dcbc43951541a290f9433f141dd8e207" => :mojave
    sha256 "a678ade8fabca1d56a30053aea11beeeb7daa6e4e1e75bd7a88ee8adc4608a3f" => :high_sierra
    sha256 "c60a4cca87007b777dc4d18343475e0cacb5a5e92c4b81e345542283465910e7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    (var/"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    output = shell_output("yaf --in #{input} | #{bin}/rwipfix2silk | #{bin}/rwcount --no-titles --no-column")
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
