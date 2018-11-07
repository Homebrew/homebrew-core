class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.17.2.tar.gz"
  sha256 "70b74eceafce7b724ceccd9e801909f4bd28985406eb8c42a94c8d25e7d58194"

  bottle do
    rebuild 1
    sha256 "4e308eeaef5f1be5c4be0ac6ba57616cd2dc945e2edf9f0916127e8ca6118616" => :mojave
    sha256 "6465b56369992120281899c1d43bb7163958c976ad50630cbcc1c19284bca0ae" => :high_sierra
    sha256 "7c50646eddfea6779a412d8a17dc2e80a258ab7fee136c5bc43f9613ec4ba213" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

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
    output = shell_output("yaf --in #{input} | #{bin}/rwipfix2silk | #{bin}/rwcount --no-titles --no-column")
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
