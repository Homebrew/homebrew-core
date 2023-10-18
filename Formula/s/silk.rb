class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.22.0.tar.gz"
  sha256 "15cff02484a75ba3c297067d57111f29751f1c94d6f66a5f4c27877268713e80"

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "d55fd5a298a8f38b75c06499aae9479cef40fe4995c4f603a697a91445755e16"
    sha256 arm64_ventura:  "aea222dd35e5aa14c1b47a2924b789d10061a6422971968acfac53e59d867857"
    sha256 arm64_monterey: "9cc8828c814c44117937312cea93884aaa382e10b55868fc886de910729bc941"
    sha256 arm64_big_sur:  "d7fa36cb46078656589b85fb74de2841f221322782a2f05e6cfd3e9111fad68a"
    sha256 sonoma:         "201aa86a04505ab3fcb9e62779b9cd91181a6d790bf45feb0463658903da59a2"
    sha256 ventura:        "9c039c8202ea8dd3a535df5f91d3968407b0e97a001163ff6f2c000ca963e3ce"
    sha256 monterey:       "1744a21267addac3b26a9415cfd8e0968b1de7a10aeedbf785d6dba02c8888e2"
    sha256 big_sur:        "e45decd58d32300f366721e3bdce32f89f8be24baa2c81b3c8e693eb6f5fdb48"
    sha256 x86_64_linux:   "66c190c95dd8b764c4dbafeb8e8d5808cd0a867207b10ba3fff582b976aac1f4"
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
    yaf_output = shell_output("yaf --in #{input}")
    rwipfix2silk_output = pipe_output("#{bin}/rwipfix2silk", yaf_output)
    output = pipe_output("#{bin}/rwcount --no-titles --no-column", rwipfix2silk_output)
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
