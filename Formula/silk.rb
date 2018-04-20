class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.17.0.tar.gz"
  sha256 "11a20dafdff67b6c412d988d567946c047a3a301fa922a37dc6bfaa00751de37"

  bottle do
    sha256 "88d56947e5912978cfffc9e5e421ba7b923df3128ad4c303351c1d62dc605816" => :high_sierra
    sha256 "fe1cb39f2915226df00b8fd321d5265eafa3a804996b4946a69a1e48de24adc5" => :sierra
    sha256 "9fa14b7dac6e5e8fcd6197cc90f581440b18ea6fa2fc35e46bd449f8f5d1f697" => :el_capitan
  end

  option "with-python@2", "Build with the PySiLK python interface"

  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"
  depends_on "python@2" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]

    if build.with? "python@2"
      args << "--with-python" << "--with-python-prefix=#{prefix}"
    end
    system "./configure", *args
    system "make"
    system "make", "install"

    (var+"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    output = shell_output("yaf --in #{input} | #{bin}/rwipfix2silk | #{bin}/rwcount --no-titles --no-column")
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
