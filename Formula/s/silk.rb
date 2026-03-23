class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.24.0.tar.gz"
  sha256 "9292f6c90cd324e2dde58faa77e74cacd1398c27b5cd6bc3f194409b07c4affc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :homepage
    regex(%r{".*?/silk[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "62c5e375b47fcb9a747c75df78726a7af448ed64351b7fe05a9366edf12a5417"
    sha256 arm64_sequoia: "b8104aeb3b0fdc9c27b9fb77c2571db56ae8321e19809429ff63b72d65e06925"
    sha256 arm64_sonoma:  "b4e5dccbdeb34cb2e583c3a725c62fdc0157524e9b2e5235628c13c08e6c1bda"
    sha256 sonoma:        "08fea9effd361b4ccedb1326cfcaf89dbf0d749be5a7da9eb13c6f5c5ff7e635"
    sha256 arm64_linux:   "79817e939510b3a190a5bbe060f485db4a8a3407ffe9c6dd697ad3810af601d3"
    sha256 x86_64_linux:  "aa66713652c68c56a72f918a90839498f9f04a197fe8ad9384c207bb73552601"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
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
