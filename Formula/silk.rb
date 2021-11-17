class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.19.1.tar.gz"
  sha256 "b287de07502c53d51e9ccdcc17a46d8a4d7a59db9e5ae7add7b82458a9da45a7"

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "e61fe7782170368f91f5f8a2460eb68614a917dd6801c1c912dd9435bc2b4134"
    sha256 arm64_big_sur:  "8d3c65086a32469d221ca03666c9c54f9b16dc3a83cd3906ac46676d0f7139fb"
    sha256 monterey:       "e66170610be0b19075b7c59882b9b4c305c30f1090fb3926bfb71f404ca4490c"
    sha256 big_sur:        "6fab609033d87aada95d080cbc49b4730bb4b07d77b58eba8f6244773e2ca999"
    sha256 catalina:       "4a88b111ce742a948b91b9441f2bbc7e821ffd3691673086ff46e8e27fbda31e"
    sha256 mojave:         "923bc8b774f207d23073195b49befba72e378e79846b6809066f55f3df87c329"
    sha256 high_sierra:    "663d2a858210750b8650e4f0e516dd6530fb5d08a7c501f8daa937572d8a81ee"
    sha256 x86_64_linux:   "260d96b7167b57d9fb2be97dd9632a6e8877633cce28331ea2b9d6fe21ff5019"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
    yaf_output = shell_output("yaf --in #{input}")
    rwipfix2silk_output = pipe_output("#{bin}/rwipfix2silk", yaf_output)
    output = pipe_output("#{bin}/rwcount --no-titles --no-column", rwipfix2silk_output)
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
