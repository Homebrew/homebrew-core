class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.22.1.tar.gz"
  sha256 "e10096e9fa4ef4980cfff300b8f7a0aed6a8e8f172b444e43dd79ed7e05a7e02"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "23982b07413ed4356a99a6ed3576ea4ac27e5778365a54e2fb2575a3e4d122a2"
    sha256 arm64_ventura:  "858a59adacf668be7ec4639c4e31ba5cd29eca68c150dfe612305c709e3551c2"
    sha256 arm64_monterey: "d540bfded64ec2c474850b5d1bcca5841508cfc82ebc6c0ed870408484c90944"
    sha256 sonoma:         "05d6d698a514948edc2388368691692a79b08197d4e05f383772f4e5ce2c0289"
    sha256 ventura:        "e31aa50979848bdbd50a1576029b3b752c637df316980e620bcc5d1bef7ffb60"
    sha256 monterey:       "9ee2b6fe90d8d3443d30ef10dd50a68d73efdb165add96722a29eaa8024b53a1"
    sha256 x86_64_linux:   "b67eda379dc8d08d84b165bdb01be10227ea7ae1663744f8e2e49c59d170ddf7"
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
    # Work around macOS Sonoma having /usr/bin/podselect but Pod::Select was
    # removed from Perl 5.34 resulting in `Can't locate Pod/Select.pm in @INC`
    args << "ac_cv_prog_PODSELECT=" if OS.mac? && MacOS.version == :sonoma

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
