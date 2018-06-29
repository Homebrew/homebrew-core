class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.17.2.tar.gz"
  sha256 "70b74eceafce7b724ceccd9e801909f4bd28985406eb8c42a94c8d25e7d58194"

  bottle do
    sha256 "ccc428b66b99acc23d7affb07092cc98e77a3fd8802501500273b272f3f16043" => :high_sierra
    sha256 "5ba88cf5e142bb839c006ee1663b01795eb29dd987d8ed0738a61fbf4b922321" => :sierra
    sha256 "d90ea3352ba364ec403c56712b0503fe2c4e67e678d4a5147868eb1c233926ff" => :el_capitan
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
