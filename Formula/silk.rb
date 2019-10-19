class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.18.3.tar.gz"
  sha256 "25fc734d6cac7d39285877ff5efd78bd4e5bb34523a6c4f6174afc9e2a87c2a2"

  bottle do
    sha256 "c90d8dfbda150c1a97e55a749fec32291f85d49479dd2726fbf48b9708c09fc4" => :mojave
    sha256 "69d9342a0ebfa1429437d3fe656f531599b349da0ab4d057f46c8fd47b841fa3" => :high_sierra
    sha256 "7b0527921b55dab17386e5d334179e7eaf87cc5e1a19fc6df067b2078dc3e43c" => :sierra
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
