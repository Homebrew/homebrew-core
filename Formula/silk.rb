class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.17.2.tar.gz"
  sha256 "70b74eceafce7b724ceccd9e801909f4bd28985406eb8c42a94c8d25e7d58194"

  bottle do
    sha256 "b504b58eaebdc19314ee7aaa999ad4e29bc57dfdabd64f91a39fd6cd8f3a2e9a" => :high_sierra
    sha256 "59b3b9eadf93a259d938929e85c7541809db128fbbfb407ab4e5bd9e470ba70b" => :sierra
    sha256 "ad7b9a29d9b7b648501a57426acd3e92655ffaf760dcfa6cacd1bc6221067d89" => :el_capitan
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
