class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.12.1.tar.gz"
  sha256 "53bbdfddd4d6f59ac0d866fdb20e59653cc7f8541b44044bbb1ec1f981e21e27"
  license "GPL-2.0-only"

  livecheck do
    url "https://tools.netsa.cert.org/yaf/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "76f4110e69d43358fe777fb8592a1b70a7d559f5907f7e8a49498ceffaefb58a"
    sha256 cellar: :any,                 big_sur:       "c1b74fbe1059282892a5b6ffaa20ab78a2a826e012dd9660ca3d47620cf5c5c4"
    sha256 cellar: :any,                 catalina:      "916e896ce18eac857a04e804dd1e71b5db9d35bb140c07dbf6da3db392022ca9"
    sha256 cellar: :any,                 mojave:        "a3cc7c4da5056644725dfe0316140886199c6151bf868e62765ba4c2fe07d0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2ba016231be6eaf8916076815ac8c0d5b3cc9c75eb2d2b06580c8153f8cd2e"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"

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
