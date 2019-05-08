class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.18.1.tar.gz"
  sha256 "0900a5a0d08c786be280d97e5bb6d9ec09e8aec69f4495a91b32e254014ef8e9"

  bottle do
    sha256 "d42adafb75701fcc754c256a89a1c585ae0a4770c09c76b0f0d4d1789f576a1e" => :mojave
    sha256 "96eefe797189de74e82d10e9988416878a57ee3c1264dab6cf8476b25b55fe11" => :high_sierra
    sha256 "a7ade89a1b415e08676dd8f8d0d69494d3b6346406fdca200e9388c99f3e61f0" => :sierra
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
