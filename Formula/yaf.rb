class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.11.0.tar.gz"
  sha256 "5e2523eeeaa5ac7e08f73b38c599f321ba93f239011efec9c39cfcbc30489dca"

  bottle do
    cellar :any
    sha256 "c2b96aad363ab74963c8b7659845578813ff1c866a440246b78c4c442d552ebf" => :mojave
    sha256 "8eeb9c55a48289c0797eafd00563adf0baae88df44a38397ca6b48cba15ca6e9" => :high_sierra
    sha256 "62175a5fd81fcf2b4677c7a67ae13e8a6c6943ca26d93d3d5c07052dff5446f1" => :sierra
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
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
