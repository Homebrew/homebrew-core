class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.18.3.tar.gz"
  sha256 "25fc734d6cac7d39285877ff5efd78bd4e5bb34523a6c4f6174afc9e2a87c2a2"

  bottle do
    sha256 "5248ab37b8ab6b5f4af1247b336a010fa7903a9aa26cc5bcc2fc3186ca1e3313" => :catalina
    sha256 "bede7abfbd61702f7bf34f57fb15ffc179c59e8224aaad8e2caa2a25582a8b96" => :mojave
    sha256 "90a46c1d80f214041df14dc7d8b680901a9bf181292164bf231bd1959f3214e7" => :high_sierra
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
