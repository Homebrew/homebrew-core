class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.17.1.tar.gz"
  sha256 "1580dfabc3ff8cb90b0f303d5758d8be4515f130931601c49c05895f0bd1e1a1"

  bottle do
    sha256 "8415f76295534e23a7641ac1b263002b32f3b623a1ac4eb955f3ec9585d781a3" => :high_sierra
    sha256 "f394ea7555171fdb0c069579d78bb221fff638fa018ff85ab7684b6960a0a2aa" => :sierra
    sha256 "a378d755801eb5d058c8d2d09a574b6323725c2f0e26e0b8b760d8ea2b661dde" => :el_capitan
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
