class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.22.2.tar.gz"
  sha256 "81b38f3e648bcc9125124df69516d9c157e28e1efe693bd2ff57212e9ca10af3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "8770e385d7b38b4db65c3fbc1f5caf6591f2e9ff5fe56dddda6357cc52780235"
    sha256 arm64_ventura:  "a019206b30a3ea4b3e4dd2be9bd169b48c67f4a8bccb9c268c937fea4d1c9157"
    sha256 arm64_monterey: "c5b068ff80bca89aea576b6e0090dfc4c1f265c4d031c2aee597e89be9978a5d"
    sha256 sonoma:         "778ddd419e17214dac4e29a38ce47f2a9b39987379b49eb54d98ba3049768bf5"
    sha256 ventura:        "7ce24ddfbece66b321f379233b23226740599e5194f8996a441da4585bb0c669"
    sha256 monterey:       "46315c88a3ac3476b909dfa0fa20d571702aadaa35c3c3e4458ffbe407aaa361"
    sha256 x86_64_linux:   "5e9ebf1fe8edc1c699cc7748e551449f2557dfa3129efa43e532032a505a7c50"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    args = %W[
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]
    # Work around macOS Sonoma having /usr/bin/podselect but Pod::Select was
    # removed from Perl 5.34 resulting in `Can't locate Pod/Select.pm in @INC`
    args << "ac_cv_prog_PODSELECT=" if OS.mac? && MacOS.version == :sonoma

    system "./configure", *args, *std_configure_args
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
