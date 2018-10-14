class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.10.0.tar.gz"
  sha256 "ed13a5d9f4cbbe6e82e2ee894cf3c324b2bb209df7eb95f2be10619bbf13d805"

  bottle do
    cellar :any
    sha256 "78030c3f91bb5d32077551d79312dc3d6afa7c7ca8d4c408085e49de57f322cc" => :mojave
    sha256 "73abcfccad6c16bfbc84add0d00976cc14ea37334d8115a07c6e50a033976eb5" => :high_sierra
    sha256 "d5bb7f21d52b91f6c646b6e3418e8b5a48eaf3fd2573788bc72ced80d64dcf31" => :sierra
    sha256 "68b68bdf4ae89e1bbe047fe39bab0d7d09b138bf12091378689f100b286d899e" => :el_capitan
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
