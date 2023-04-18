class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.19.2.tar.gz"
  sha256 "358ba718208dcfb14a22664a6d935f343bd7a1976729e5619ba7c702b70e3a7d"

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "d9ee4215944603be82971a85a4ba5823459cde29ec59fd2de00b84687c859512"
    sha256 arm64_monterey: "1dbc420aa255de275e130e8badfd42fe90fa1e8a3a0e20c6c2f657810b1f632b"
    sha256 arm64_big_sur:  "c1ccffa9868d0dda8d58ca4f967a377edc87d92fa7290c142fe1f1864891b2e8"
    sha256 ventura:        "ea2b9d55f3939a2c18084f7f0c08ada6ba3c0fe9f929443315c9f9534c8bd087"
    sha256 monterey:       "ecfdbcdc417073b477294debeaab6c64d4357e3424c19571b8ae8bc8074936d3"
    sha256 big_sur:        "a497049c441a67e363c76207398d5c26384ab6ecbd4b7e0cd850e08ba06e05e8"
    sha256 catalina:       "c6e3891773f58ee6259c73662aa37e7158c1e50aa1e172a5e11eae85104f62a2"
    sha256 x86_64_linux:   "384156b0533c8d0b0c206c5b3c78fc9cc2787e7a36d6c8f6807086084be5e902"
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
