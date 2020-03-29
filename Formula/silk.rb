class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.19.0.tar.gz"
  sha256 "0f5bdcf437a1dc0429a5acb48b8e9ef18050999a230920369c05b2db9f020695"

  bottle do
    sha256 "1e9d81c01f87a3f0edc251a1623f44f64aaa6bccda5ed3ea6291d163519e7600" => :catalina
    sha256 "a4b52045add179910361637d4c5b69f67f8587579a0f48b8b7b2f5df9b820579" => :mojave
    sha256 "f454d82c526c74756a99b67b8b4354bd45ad3196d3b626877bb14f70b4404df6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"

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
