class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.23.5.tar.gz"
  sha256 "58701cd3b7ceb951fb5cda9c241b171608036daab4bad4893f6882f4a29b1680"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "95e2f74ac394bb9327e6e54a9b60fa4a4f320f1b974c640898fea6689b42bac4"
    sha256 arm64_sonoma:  "861f979e9ca355c2bfcbfa383f1b052eaf98bf8550c8b8eccea603a7ca83db1c"
    sha256 arm64_ventura: "ad2454feb3a3a60d32b8e889ad387fdc0408c84522dfe9af6c34cb32710d8c2b"
    sha256 sonoma:        "155ccf0867d12599b416cb34c00f1e082894cd43462b206a09a6ee8e0cab363d"
    sha256 ventura:       "f730eb216f5b4bf435000d1dfe1197a87c2f2ac4d25c3ff45e7f9d433b6760d4"
    sha256 arm64_linux:   "f13652d2d255490d21f8b4cac9f5da8f8e3aaf2c1d50032d6d3c000d53eaacfd"
    sha256 x86_64_linux:  "1b93547929821cca240e813162e1d6ff3066c4dd6df50060c027b59f33b6f6bb"
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
