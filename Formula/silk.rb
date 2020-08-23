class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.19.1.tar.gz"
  sha256 "b287de07502c53d51e9ccdcc17a46d8a4d7a59db9e5ae7add7b82458a9da45a7"

  bottle do
    sha256 "4a88b111ce742a948b91b9441f2bbc7e821ffd3691673086ff46e8e27fbda31e" => :catalina
    sha256 "923bc8b774f207d23073195b49befba72e378e79846b6809066f55f3df87c329" => :mojave
    sha256 "663d2a858210750b8650e4f0e516dd6530fb5d08a7c501f8daa937572d8a81ee" => :high_sierra
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
    output = shell_output("yaf --in #{input} | #{bin}/rwipfix2silk | #{bin}/rwcount --no-titles --no-column")
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
