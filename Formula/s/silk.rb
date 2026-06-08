class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.24.2.tar.gz"
  sha256 "9ea9c1391f9c1ba14394af68b2bd7e66bf73b664c3cee342c5a39e5b13e45398"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "d579be46db7c40df084b647dc2b47dd8fb0b1cab1a07ffb632cbf667f98ccf8f"
    sha256 arm64_sequoia: "f85ea2f1292dc167f9b79d9323dbfbed4140a4b2424bfc29b039ed19cb45c3f2"
    sha256 arm64_sonoma:  "c003a5816ec84797681c01ac9352a73c298c4f9923d6ae7d1420a4f72a233576"
    sha256 sonoma:        "0b62ef17187839d631a23b836d774adb3b0cfcb4868640ff9226764a4fd2da0c"
    sha256 arm64_linux:   "d224302cdc2af30ae28639ad7913f44c87a67af266ba64a908f397956f9597c1"
    sha256 x86_64_linux:  "365c8f00b406b40ca57c250f269bdcd7f02e808d6a8f6c74de342f4a085868a6"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
