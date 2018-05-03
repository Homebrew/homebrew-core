class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.9.4.tar.gz"
  sha256 "abead9d8dcccfa2550fad8c412e30a2636e281546c075599f1a0c660aec15f30"

  bottle do
    cellar :any
    sha256 "06d7acff1aa0cd9d0cf74b6942b1907a2ecbce27b196581943b1397a15284ed2" => :high_sierra
    sha256 "da5003dc3645098acd782d64b51c16482216b90d2af682199ab1e30991df8ce5" => :sierra
    sha256 "593b7c05ef647cb0992d36496b1ecf96bc6a80da0b4e1f1c9f9b18ddeb30698b" => :el_capitan
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
