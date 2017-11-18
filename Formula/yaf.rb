class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.9.2.tar.gz"
  sha256 "c6246dc64d9311a098b239a313c75f793ece02bac61daf2c83c26ac868bc0def"

  bottle do
    cellar :any
    sha256 "f47d739035833d33a105293d3eb4eb7f87766b41d942df5005dfa4d59eae274e" => :high_sierra
    sha256 "49a1bd9985b81bb194316c32b19b337606d8b4b5f97af223e453968c222a9f6f" => :sierra
    sha256 "775af7ba1c043f57c01bbe0ceab5d3eab7247a529191e9a042360f939c742da8" => :el_capitan
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
