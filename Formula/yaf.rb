class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.9.3.tar.gz"
  sha256 "a0dd7f8f8733b8554ee0b1458a38fad19734899313ed4a4eb9bcf96893d98e02"

  bottle do
    cellar :any
    sha256 "24422434ea23843b2ae740613df6e275d6ca7428fb18edf6d859a8e424da8fe4" => :high_sierra
    sha256 "07ed2f7990b8ba323ea4086c33d6c1dad14dd9896b2e477f2e72d229b2666155" => :sierra
    sha256 "a78d64bc822e5238b8959c29f6b2fd3b0c5dd394e035f467115fae1a00e5f8c8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = `#{bin}/yaf --in #{input} | #{bin}/yafscii`
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp 192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
