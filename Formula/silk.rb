class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.17.0.tar.gz"
  sha256 "11a20dafdff67b6c412d988d567946c047a3a301fa922a37dc6bfaa00751de37"

  bottle do
    sha256 "855f915a2f80d99d93871ac59761119c49ff18eb5a6359380ff1a3d1d0a3865f" => :high_sierra
    sha256 "e3b55bdb628ef4b8a036d108e20ae8bdc2fea365ec8fb1ae3ff310863dd55fff" => :sierra
    sha256 "7ea7355e597e939ab39712273e2eb3922552eb7213f61462a0577512aa110567" => :el_capitan
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
