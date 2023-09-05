class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.21.0.tar.gz"
  sha256 "312cc4041e8f36f6586c54af861df6ceef7927693db23c164363f38c8ef13bf6"

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "f1c3e144f57415b78b75e9714a19e561bdbf721e6654c6eb44a4081bc30f2901"
    sha256 arm64_monterey: "6ad28ddc2273eab9523814e204ca6321d9a578b4bbca2c14f1b66f9437ef3eea"
    sha256 arm64_big_sur:  "607c4569053b563068a80ef92061ca248e76aa957de0ebc54364b84ac72de794"
    sha256 ventura:        "be2ddf2600db6bd11d8c128eb2a7db005b453d5d4a90e1df9d234e51ecf4b6ea"
    sha256 monterey:       "3b280ef26f3faa4d431ea663eada8a262263884bae97f1e50d13696ce2718d85"
    sha256 big_sur:        "00e31684934953a9b640be5b9a5c8340dc96e9698daa29cd76d22962621ae95b"
    sha256 x86_64_linux:   "eea6baac12cf0fe155ab102129fdb3c5fac655a328a784882a5f30bbe980d0e8"
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
