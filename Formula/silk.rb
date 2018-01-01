class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.16.0.tar.gz"
  sha256 "152054cc717eea23543fb6c8b18270fb040c7b0df87a802038f6f1d4b37ece5d"

  bottle do
    sha256 "a1a92c152559050986f2f2d7ca3e658ca9b687416f47e4554df4395f1a57bf3d" => :high_sierra
    sha256 "d85766f4401a4449aaec268cd67fb20c73e8c0019af24285732be1303402fc61" => :sierra
    sha256 "97fddd4c70d54b6b93b06a4135f9af08d389e042ab38aaceebeb67fb39bc4745" => :el_capitan
  end

  option "with-python", "Build with the PySiLK python interface"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"
  depends_on "python" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]

    if build.with? "python"
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
