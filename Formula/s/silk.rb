class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.23.3.tar.gz"
  sha256 "7f918626031f9543bd7ca7762f12ec56ba3ec2bf3298d319a15437b4ea1369c7"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "4ec08564f5bc0da08669fcdd552ce86a8a1208f0fb901aed2d92eed840fd1acd"
    sha256 arm64_sonoma:  "80f77b63679bcfd3999be42d31f6da5b76656961a565e7a2464123640fb4855e"
    sha256 arm64_ventura: "5e5d808fc887a8e6dfa50d087046c89f40683403444133ad9275ba46f9904997"
    sha256 sonoma:        "546bd6104614d6f05e53bac28a160a6083921d7357d0fc59e7ca1c804daca899"
    sha256 ventura:       "de93ae1b70d76f666c5a03d70741a51c910f93a4822184031e3704adb2765c2d"
    sha256 arm64_linux:   "20367aac96d0ebcd7f9fef99ce1bb9d63936d6d197cb64ee73d67bcb69f8178f"
    sha256 x86_64_linux:  "09cf4e1b3f3492c1245f04da0eda5fd741fa96238fe8eff9c16bd7b8c7ce1251"
  end

  depends_on "pkgconf" => :build

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
